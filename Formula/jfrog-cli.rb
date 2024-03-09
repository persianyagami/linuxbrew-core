class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.42.3.tar.gz"
  sha256 "4ff77e176e6f10c4b0c720a2bb365990d0afa10f15993ce92fad6f0a69ad262d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6c95200a5fce603571c18d2757de906568cb82cc4b57de2af1be60ea81c8e7b" => :big_sur
    sha256 "1f81ce5345aa8837e2808c7e69a29f12ac48890693dc46ba3418990f7aa71b55" => :catalina
    sha256 "a8861025ae532b162664471b417d3b6199c725f7fb265b043adb427c7d629af7" => :mojave
    sha256 "9b3a26c7ba9ddb9ff4418878bdb4598c3a200b2860abfa97d1e81e41594f3c8e" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
