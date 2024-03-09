class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.12.0.tar.gz"
  sha256 "cc547d58c1402f6724d3ff89e4ca83389d9e2bdcfd9ae3d695fcdffa50a625a8"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "09f89477a5fa66959801037615fe6c9319a1fff18727d9afac6594e3cc23bde5" => :big_sur
    sha256 "473370be4a7aec5d807ab8f17b75555939b5dc6cf38fb9d2b038349b04ca9c79" => :catalina
    sha256 "ba63b7080abeab28a37b0e49bf5ded80d67f931020117386285c94dd4090f995" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    system "cmake", ".", "-DBUILD_TRANSLATIONS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qt5keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    EOS
    args = ["test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
            "-L#{lib}", "-lqt5keychain",
            "-I#{Formula["qt"].opt_include}"]
    if OS.mac?
      args += ["-F#{Formula["qt"].opt_lib}", "-framework", "QtCore"]
    else
      # Fix error: You must build your code with position independent code if Qt was built with -reduce-relocations.
      args += [
        "-fPIC", "-L#{Formula["qt"].opt_lib}",
        "-lQt5Core", "-Wl,-rpath=#{lib}/x86_64-linux-gnu:#{Formula["qt"].lib}"
      ]
    end
    system ENV.cxx, *args
    system "./test"
  end
end
