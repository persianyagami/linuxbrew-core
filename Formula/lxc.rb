class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.19.tar.gz"
  sha256 "6e4cf6cb1549e1b56802d64ad24d812914e0c0102bfcf146bb18a8dcd1fbab57"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cbbef2f6c2fc729ef7c9d4b5602715aa3045596bae6f259fcf90fb5c10cfaf1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ba5f63e307465a3a961287559ce3473635ab2fcc2f73fe40fb5376f44b97881"
    sha256 cellar: :any_skip_relocation, catalina:      "725720b4449d358517318a8d8a29df5dc9f476369ee8ba9c43b3ae0c53624b42"
    sha256 cellar: :any_skip_relocation, mojave:        "5b52391136e53d428740b1eca815d61b9aa7c4f31c43924833ed9e2cb2db6323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0cac50cfb1aba99241d2f2ab656ec73553ae3a957d4365db827bc4b61c78cdd" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
