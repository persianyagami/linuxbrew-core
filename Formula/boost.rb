class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_75_0.tar.bz2"
  sha256 "953db31e016db7bb207f11432bef7df100516eeb746843fa0486a222e3fd49cb"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  livecheck do
    url "https://www.boost.org/feed/downloads.rss"
    regex(/>Version v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    cellar :any
    sha256 "82791d5a9dce5635e6617b62e06470f8f8656c44c1ca6bdf90f1a3067e54dd3e" => :big_sur
    sha256 "fd474d98bd2d23a4065035034b4ef417108cb8ee2bbd04c2de54e21d6e6fffee" => :arm64_big_sur
    sha256 "937f6bf0106e3b31ef0ae3a4f9a3abf1af7f4894a72b17f07c0e1f324281446b" => :catalina
    sha256 "32cd0dc0602e92efe8d75a74db20388b4885df4bb2e8123694b6e3fa2328fb82" => :mojave
    sha256 "d903bcaca2f2c1d6f61981e8e266971c59cbbf6df2634f1082f8529d1f06e994" => :x86_64_linux
  end

  depends_on "icu4c" if OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix build on 64-bit arm
  patch do
    url "https://github.com/boostorg/build/commit/456be0b7ecca065fbccf380c2f51e0985e608ba0.patch?full_index=1"
    sha256 "e7a78145452fc145ea5d6e5f61e72df7dcab3a6eebb2cade6b4cfae815687f3a"
    directory "tools/build"
  end

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula["icu4c"].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
    ]
    bootstrap_args << if OS.mac?
      "--with-icu=#{icu4c_prefix}"
    else
      "--without-icu"
    end

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      -sNO_LZMA=1
      -sNO_ZSTD=1
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Fix error: bzlib.h: No such file or directory
    # and /usr/bin/ld: cannot find -lbz2
    args += ["include=#{HOMEBREW_PREFIX}/include", "linkflags=-L#{HOMEBREW_PREFIX}/lib"] unless OS.mac?

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    if OS.mac?
      system ENV.cxx, "test.cpp", "-std=c++14", "-stdlib=libc++", "-o", "test"
    else
      system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    end
    system "./test"
  end
end
