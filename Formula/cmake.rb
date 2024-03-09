class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.2/cmake-3.19.2.tar.gz"
  sha256 "e3e0fd3b23b7fb13e1a856581078e0776ffa2df4e9d3164039c36d3315e0c7f0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url "https://cmake.org/download/"
    regex(/Latest Release \(v?(\d+(?:\.\d+)+)\)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "474ab1548e4909a2565f44c46f90d03061211f695403419aedc2d7a2b71f1db0" => :big_sur
    sha256 "ae145ddaf2b17c3a02cf76f06cb217fae88a0a009e409de00fa1b347a00b0c16" => :arm64_big_sur
    sha256 "4119d81cfa8435976e667af76a8b79a35f34d97aab69b646b2356eb69b8edf78" => :catalina
    sha256 "2b2cee31bfce62a116567bc295eca855b008630aafee860051aaa599eac7d657" => :mojave
    sha256 "a8a5aa9dd45f36676f17536f4ff1b72aec6320b02000c18a734c36f7fbe70d27" => :x86_64_linux
  end

  depends_on "sphinx-doc" => :build
  depends_on "ncurses"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    on_linux do
      ENV.cxx11
    end

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
