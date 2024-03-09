class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.39.tar.bz2"
  sha256 "4a836edcae592094ef1c5a4834908f44986ab2b82e0824a0344b49df8cdb298f"
  license "GPL-2.0"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "d01d066dbc2b58d856f14b9bfaa2a0f2bdfa9fab1425b24caf47239022beb365" => :big_sur
    sha256 "1a709a3b3f49b0fb1476e4fc2d7776fcf2496472a1361909d955ef8ced9ea198" => :arm64_big_sur
    sha256 "192fb153fd3471c6491a444de03aac3b65479675ffa3d830330106676f309a3f" => :catalina
    sha256 "1f6be0800675342ed83ab22fc85a3335d14514bbb7d718a8082147fdf6594249" => :mojave
    sha256 "4a973d0829eea76e5e792afd22411f730c88676c6dda7060e56e111a8fd8351c" => :high_sierra
    sha256 "dcf1246cfbbfd85cb90d92754aced3f15e1843aef4872a87a3a6b87d6afdc002" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
