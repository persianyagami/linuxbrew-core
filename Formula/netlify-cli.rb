require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.13.0.tgz"
  sha256 "2db2f9457710fe0c1efece029621c0e93301d3e6b24ab22d55abedcb02370f7e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e642542fd532110be4054d624978341d8430712d0cd0c16b6a84cf22ecd2e081"
    sha256 cellar: :any_skip_relocation, big_sur:       "635b11f35185965aa96a92baa59ce212b4fb09cbd98bb1be3621327dba0a944f"
    sha256 cellar: :any_skip_relocation, catalina:      "635b11f35185965aa96a92baa59ce212b4fb09cbd98bb1be3621327dba0a944f"
    sha256 cellar: :any_skip_relocation, mojave:        "635b11f35185965aa96a92baa59ce212b4fb09cbd98bb1be3621327dba0a944f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb04b454530792b3b25ce789fbcb750ee31d7993d1233ca3126222ddc4147a6d" # linuxbrew-core
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
