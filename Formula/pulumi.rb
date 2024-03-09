class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.16.1",
      revision: "7e3d69a53ad34134f57d9bb3ad62d4e5d95f5723"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a4fdc8d1f610b38d2296114b96b104249755e54608c622b118753ac679aafde" => :big_sur
    sha256 "47a69b5070d5f1a7eff4669e917607926a252964ac7e6d5e63a93f461d998687" => :catalina
    sha256 "38efcd888ac7d750ad99eb0a77da6b4f5bcd10d1cea611acfa559e4daa00214e" => :mojave
    sha256 "888d13a60db66ad124919b91882e096082f10f65e82cb312bf671c1b775a0365" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
