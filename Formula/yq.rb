class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.1.0.tar.gz"
  sha256 "2ff35db36b2d8226d181deb02b8e80ea7f6d4fbe04b7942fc5de2470e91b66d5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "92877d8baaef5809c61189100045020edc9aed99c66f6134776a8e64b1b495f5" => :big_sur
    sha256 "85a259decd4aae3e1dbb0456c9c2da622148a53442688b89c5fc13ccadfa0958" => :catalina
    sha256 "23cab616c9701d88bcbbc9bcc91662c94e132e3dd80c29c8b5ad160658c47315" => :mojave
    sha256 "d1044b71f4af3d9ad04e097df853e3d6ca5ea1cd26d8e74af2965eb529fe0135" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval --null-input \".key\" -", "key: cat", 0).chomp
  end
end
