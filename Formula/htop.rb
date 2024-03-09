class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.4.tar.gz"
  sha256 "d8a0536ce95e3d59f8e292e73ee037033a74a8cc118fd10d22048bd4aeb61324"
  license "GPL-2.0-or-later"
  revision 1 unless OS.mac?
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "5b426171d65d806dd20cb54ebc86bba7f3f3093242de8a3a88492a90f07c14c7" => :big_sur
    sha256 "f2d386785f45508a062701ce936e316daf8c312d73da02cb3c58ef79393e3a53" => :catalina
    sha256 "94975a5e046d3a4ee564c7a8d75355f91138f818e6782dcc8ca07e08fb18bf8e" => :mojave
    sha256 "48bc41bfe1dab0e67a7e464ab0a39f1c7ee4f8beaf04227865bed97bea7305c7" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "ncurses" # enables mouse scroll

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin" unless OS.mac?

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
