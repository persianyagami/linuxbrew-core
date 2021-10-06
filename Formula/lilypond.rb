class Lilypond < Formula
  desc "Music engraving program"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.22/lilypond-2.22.1.tar.gz"
  sha256 "72ac2d54c310c3141c0b782d4e0bef9002d5519cf46632759b1f03ef6969cc30"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://lilypond.org/source.html"
    regex(/href=.*?lilypond[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2c801f4fdde1ed6e006eeae104804f64878d2d87299090b2e24670272dc76f49"
    sha256 big_sur:       "494460d9f2e9027ef52e8fd6d81869689ebc45d433403c25202e0c9d09c520bd"
    sha256 catalina:      "1273052a8fb3584c5abbcbfa2492c0de3e1ae62496370fffd6550a22caeaa88b"
    sha256 mojave:        "0828c31c729f5621d64d554afd01bc5ccf5d604b976b064f5dd5450ed9a3dd59"
    sha256 x86_64_linux:  "00855d98c08ca3cc3e9d5f114a5935216ab40d40d54c4c35071930e60154fc1d"
  end

  depends_on "bison" => :build # Lilypond requires bison 2.4.1 or above
  depends_on "fontforge" => :build
  depends_on "gettext" => :build
  depends_on "glib" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "t1utils" => :build
  depends_on "texinfo" => :build # lilypond requires texinfo 6.1 or above
  depends_on "texlive" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "guile@2"
  depends_on "pango"
  depends_on "python@3.9"

  uses_from_macos "flex" => :build

  def install
    system "./configure",
            "--prefix=#{prefix}",
            "--datadir=#{share}",
            "--with-texgyre-dir=#{Formula["texlive"].opt_share}/texmf-dist/fonts/opentype/public/tex-gyre",
            "--disable-documentation"
    ENV.prepend_path "LTDL_LIBRARY_PATH", Formula["guile@2"].lib
    system "make"
    system "make", "install"

    elisp.install share.glob("emacs/site-lisp/*.el")

    libexec.install bin/"lilypond"

    (bin/"lilypond").write_env_script libexec/"lilypond",
      GUILE_WARN_DEPRECATED: "no",
      LTDL_LIBRARY_PATH:     "#{Formula["guile@2"].opt_lib}:$LTDL_LIBRARY_PATH"
  end

  test do
    (testpath/"test.ly").write <<~EOS
      traLaLa = { c'4 d'4 }
      #(define newLa (map ly:music-deep-copy
        (list traLaLa traLaLa)))
      #(define twice
        (make-sequential-music newLa))
      \\twice
    EOS
    system bin/"lilypond", "--loglevel=ERROR", "test.ly"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
