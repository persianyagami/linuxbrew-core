class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.6.2.tar.gz"
  sha256 "f2314d8e5e133a6ce93968b3450c1710a3e432cb4a5dfc528aa0317d968a8988"
  license "MIT"
  head "https://github.com/muesli/duf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2a71c40e8e3fa589804c5dbf0db6902fb975dda4d041a2a4b71807154eb5c067"
    sha256 cellar: :any_skip_relocation, big_sur:       "532553ff3bc0b3e1a3102043eab1f02560741f6e41d284738bc2906e92bef55f"
    sha256 cellar: :any_skip_relocation, catalina:      "7a2781e6da9734ce9fd6a902a66306c9afdf7f31796479f63bc24e0ea1626d22"
    sha256 cellar: :any_skip_relocation, mojave:        "4016e727433f48e0c1730bff8f82a6c9ef2595b5912aac1e92ca0c74dbb51bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be28273df84d21725159f3101e4a32f555773502d50fd5b41bc94883606f689" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"

    devices = JSON.parse shell_output("#{bin}/duf --json")
    assert root = devices.find { |d| d["mount_point"] == "/" }
    assert_equal "local", root["device_type"]
  end
end
