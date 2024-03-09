class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.26.tar.bz2"
  sha256 "517569e6c9fad22175df16be5900f94c991c41e53612db63c14493e814cfff6d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "a1db191cf5ab20227a649f8a115fac58d36ef5246eb0b2cc1263fa90d774dec8" => :big_sur
    sha256 "b8684c5b23fa30836057882dd89c4598c8d68d7126292479fa65b199f161f1d7" => :arm64_big_sur
    sha256 "ad7bcb8940279a9edaf7561a1244b7bcd346c0a800a8db6e3b53cf239a98e98d" => :catalina
    sha256 "dcb758b554eebf5bce21866d88ac2626a43f81396342266ddcaba4a1fd637b22" => :mojave
    sha256 "f471d63c91ccb19f6ab0975f21df63b2954a61443343b95cb3a85e68ff5a5673" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "adns"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"

  on_linux do
    depends_on "sqlite" => :build
    depends_on "libidn"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--enable-symcryptrun",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
