require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.22.0.tgz"
  sha256 "3bc2bd619ca733dadba371b80d31fc9ae4f65f44e733a3f8a4c241b6804cc42f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c003e922402da8dd08a06b7ce46a22526681e7f5288653bab9b10c9d7422575f" => :big_sur
    sha256 "b3e1f767f77fed1ca76dad1e43f2c2e287082398ea23e53fc16671f8ac10aacf" => :catalina
    sha256 "3c16fac57b64ceca1b93e02c1c41905dbb7fec48be7afb26f76e7073c1eeb5ac" => :mojave
    sha256 "bc24ef50b3688cf6104f0f95e0e0c8e59d855f2aa7a81be632fb365fb7a3fdac" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
