class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.11.3.1/pandoc-2.11.3.1.tar.gz"
  sha256 "e957f94eb9514dbefd806b642e679a735c880e757bc12ba7f50d521b6d0e08e2"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "32c22a3f7419bd316d13646c6a08a03063c5426809e55f6def0d6c119afbc31e" => :big_sur
    sha256 "1b72df54161967a99a125abfed2d2e1d3e398698cf687b7112e9a3477e68c5eb" => :catalina
    sha256 "c491b83ad4687043c7f525c2db08c6fddd38261697d7463d9dae6cc42fa4647b" => :mojave
    sha256 "eae113be151df5ea499030eafca4a7c2c73252c6a67bee728f45fb5d4d7c4405" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
