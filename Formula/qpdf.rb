class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.0.4/qpdf-10.0.4.tar.gz"
  sha256 "b191dc4af4ea4630cdc404a4ee95a0f21c12f56ecc4ae045f04425464d7c696e"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "7fcecfff0483197b214c156a1708b3c8cb854dfcae8fdc3839a8bdbd37449bea" => :big_sur
    sha256 "129e28c8fb16311abbd8cb7a2fb11a2d819035809f980bc8c5152a2c0a3cd87b" => :arm64_big_sur
    sha256 "73dca004aacd24237d98c604885492e13a1156151113485df48877d99a915423" => :catalina
    sha256 "8556fd9465de6203de5104777092e3263ecb0f8b9146ff35372307ea857acd6f" => :mojave
    sha256 "7794e996655d125f3c344ceadeaca53593e650d00ce393c3f71d4544ab09a3e3" => :x86_64_linux
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
