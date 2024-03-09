class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.71.0.tar.gz"
  sha256 "87297207fc8e5c245dc49376383608c9950587463b28da2408f51038fbd67c56"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cc213cddafa9f9f624eac8b32d38b2002598094a924ab6d80aebec6f791eba1" => :big_sur
    sha256 "b7d9e80439b922ad4640d63ed0b259ec92df4c32ca92e917f5d89093960044ad" => :catalina
    sha256 "dab913047a6bda6f3a7bb60e4d04ddbf96fcb41908ab6a1f94e26b815691205d" => :mojave
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match /200 OK/m, shell_output(cmd)
  end
end
