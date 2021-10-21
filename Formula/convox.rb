class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.53.tar.gz"
  sha256 "4626f93cbc0038f5481949ad8982aaf7ac38d9d047498de659b14a5236f7d39d"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "132063210d18c9dde76061123e1f93f6ab20faf1effec5874d66935c02b62c7b"
    sha256 cellar: :any_skip_relocation, big_sur:       "33521d672ebf81aaffb43d0b7fd7cfd157aa1704ade909e10e6caa3aab87a9e4"
    sha256 cellar: :any_skip_relocation, catalina:      "fd53356e3f959212f863e405da05b2d26bf9d205b0513878104a2517ecf592d8"
    sha256 cellar: :any_skip_relocation, mojave:        "7016d5d29e917c8264027a41076602fbe6347197235a09cdbcc088ba5304f466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cadd348b5b0d9b425010a2e5fd5cd66c90baf9360dc203a0ef7d8126b2b0e3b"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
