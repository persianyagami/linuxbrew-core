class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.8.tar.gz"
  sha256 "09d9c1a53abe734e09762a5f848888f0491516c09cd341a1f9c039cd810d32a2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 big_sur:      "a44076e41f030ddccfed6768ada1ff0201ff6ffb86cce425c3fbabda799883a0"
    sha256 cellar: :any,                 catalina:     "aa2fbe6b306de8d985d0e93f12d9f896b4f7ae5403778508d077bdf975868bcb"
    sha256 cellar: :any,                 mojave:       "dccfa0d38b7096e3c27676fd09d8984009128c1017948d711087dc9d66f44f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d0a5a73de0492ebe292dfb2b24c0aaafeef2b2c977436f8ebb96e61ab26108d0" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args, "-DODBC_LIBRARIES=odbc"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
