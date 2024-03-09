class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.5.tar.gz"
  sha256 "9e1b5546187290b265e43f47f67d4ce7bf817ae86ee2bc5fb338115b533f8438"
  license "MIT"
  revision 8

  bottle do
    cellar :any_skip_relocation
    sha256 "8748ea36f930107c5c0775a4ab6fab698ad402f6da0e76a574b2bd5b995b6fcc" => :big_sur
    sha256 "5eaccab8b08ed6cde485074adf961c56b1c28423a8d14291a1ef3a8c3b37142b" => :catalina
    sha256 "e0a19b065c490d83d944221b7860e91854f0ae5be3e13c844ded14ab4960cd3d" => :mojave
    sha256 "7ed2bbcfa7e23ec2a547ef45ee19bad16cffb6a48383113e715bcd895f8b574c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "ruby" => :test
  depends_on "boost"

  def install
    args = std_cmake_args + %w[
      -DCUKE_DISABLE_GTEST=on
      -DCUKE_DISABLE_CPPSPEC=on
      -DCUKE_DISABLE_FUNCTIONAL=on
      -DCUKE_DISABLE_BOOST_TEST=on
    ]

    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "make", "install"
  end

  test do
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV.delete("CPATH")
      ENV["SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    elsif MacOS.version == :high_sierra
      ENV.delete("CPATH")
      ENV.delete("SDKROOT")
    end
    system "gem", "install", "cucumber", "-v", "3.0.0"

    (testpath/"features/test.feature").write <<~EOS
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    EOS
    (testpath/"features/step_definitions/cucumber.wire").write <<~EOS
      host: localhost
      port: 3902
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}",
           "-lcucumber-cpp", "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_regex", "-lboost_system",
           "-lboost_program_options", "-lboost_filesystem", "-lboost_chrono",
           *("-pthread" unless OS.mac?)
    begin
      pid = fork { exec "./test" }
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test   # features\/test.feature:2
            Given A given statement # test.cpp:2
            When A when statement   # test.cpp:4
            Then A then statement   # test.cpp:6

        1 scenario \(1 passed\)
        3 steps \(3 passed\)
      EOS
      assert_match expected, shell_output(testpath/"bin/cucumber")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
