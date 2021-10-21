class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par-1.53.0.tar.gz"
  sha256 "c809c620eb82b589553ac54b9898c8da55196d262339d13c046f2be44ac47804"

  livecheck do
    url :homepage
    regex(/href=.*?Par[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "051cff1396509692262c0b1da0e923a2d00e00b2ab7d3bcfdd877c8acb76169f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9af002ed591438fc64cf745df797fdd4c6138a847c6ffe650a8371ef6a2243fa"
    sha256 cellar: :any_skip_relocation, catalina:      "457e5ff8ba94268a745fc954f84cbbaab7ac7d3a239ca602107a85a2e5d146a8"
    sha256 cellar: :any_skip_relocation, mojave:        "ef5da7a3e359ba4c72ad4f11c2f1fb18adea19c6c51409d0fc7400ec60ef2422"
    sha256 cellar: :any_skip_relocation, high_sierra:   "344dd1109a03e8c6017c2ca26a17c9f07c700c743b89b42786efce956bac70e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aff9c01b6ab56de73cb61b164ce7c350dc4cdb75b0de2676599d47dfdb358b5" # linuxbrew-core
  end

  conflicts_with "rancid", because: "both install `par` binaries"

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
