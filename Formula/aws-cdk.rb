require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.80.0.tgz"
  sha256 "e125a15950915ec48c447ba5e8bce69733de83bd735a55dc22d942386f0fc25f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ae37541bee64b30dabe4cbe68267345f689b20f7b850e1b3d4dad9581a6f9736" => :big_sur
    sha256 "c3f2f49f2563844ed3a339797e5cd55dbed61ae8052288a9375f35a5dd0d78ad" => :catalina
    sha256 "17a71ffb6bf44f4a9bc9e551215961d0899689ec5b5938625731e7e5b7fa8f5d" => :mojave
    sha256 "e1b5f479c24921b77b24b99ce306e8f5ab026227536b3ac703a6570029544cd2" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
