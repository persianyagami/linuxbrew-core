class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.33.tar.gz"
  sha256 "cd488c6067c214c9e523d244bd27a054c6eac98c808609a0caf0f5b6fb24f497"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3b1c4e8066bc7cc37fb3249b92df15ee77c9c5404e1ee4711b794e455f25083" => :catalina
    sha256 "10e4317100696362a6da9b00e2f58c0b23ae87b41c7f42255dd9a26e6602c747" => :mojave
    sha256 "bd020bfe1d53f2ca5f6347e4c826c94f9bd910142b8a364e50df8529514f4e45" => :high_sierra
    sha256 "118db2aef0f611aa57c5257180e686c0cbd2e653a85b48486d11a519abb53c45" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
