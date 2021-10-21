require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.4.1.tgz"
  sha256 "496af6056f9ae47e8bca894b4a20c4ba37043d58adbe3daeaa6439ebd1c4df76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f62806e7e82f0fddc46800e826f45bd27d40fa300d819ff365eb3b4683140b00"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffb73a738f55dc11aa3b79be7db0c2f4b973bd626b647861239c9cafe0958901"
    sha256 cellar: :any_skip_relocation, catalina:      "ffb73a738f55dc11aa3b79be7db0c2f4b973bd626b647861239c9cafe0958901"
    sha256 cellar: :any_skip_relocation, mojave:        "ffb73a738f55dc11aa3b79be7db0c2f4b973bd626b647861239c9cafe0958901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604b94f995ea222c0af4c9a140cf8c2c1070cf9009e69be2290d1420c72e466b" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"deck.md").write <<~EOS
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    EOS

    system "marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1>Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
