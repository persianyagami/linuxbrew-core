class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.4.2.tar.gz"
  sha256 "0ea10b95d6f271aef476065e6c32999c1801924ea4aa0deca32e294441e107a5"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86d49a1157d33f607df7c6f603a364f9641c5af0eb519620b81e0c788568519e" => :big_sur
    sha256 "55d577057654c48ce1b058568011c91ea7b939422f7ad11cabd2b06d3d7fcc2a" => :catalina
    sha256 "799833eef3d8111e227269ce80b042c5c8c506b529e810e0e74be04b0c851299" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=f79c06f8a811d408d7549bb01f7c7a3804b9a593 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
