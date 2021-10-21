require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-13.0.2.tgz"
  sha256 "4a3921cfe0712379c85b7cdd65ffb95eee3c435ed76d5f48b3d1c72bfc2c6714"
  license "MIT"
  head "https://github.com/http-party/http-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "80ad677e4d19c143aa11656506945f691528e1bd528a27db1eb79ccef93ea407" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/http-server", "-p#{port}"
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "200 OK", output
  ensure
    Process.kill("HUP", pid)
  end
end
