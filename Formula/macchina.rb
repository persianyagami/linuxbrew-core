class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.8.tar.gz"
  sha256 "a912c9ed7b826c969012308a8a7e120a3c3af8b8bf4cf1e062927c9301ffb178"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "874b2b4af3e8fdd8cc37296743a1cf08f4faccf935c8598e585cf30ac08404bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebe1fec3aad0174250c98f0efb1ee97643e4c4cde52960eb6cabb55f8e00e137"
    sha256 cellar: :any_skip_relocation, catalina:      "83d2331c8cfb244e5b578d05956bd6cc409538251669406b5f97705ba69e56b2"
    sha256 cellar: :any_skip_relocation, mojave:        "b8c9b063a003a5d20307b4b24451daeabd6dcae08d6607f8ba05c71088d0c21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a9244cc07488ef07f2d9caa6f1b647f4377d15272a80a5a18facaabedc3126" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
