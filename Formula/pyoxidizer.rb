class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.17.tar.gz"
  sha256 "9117d411b610e29dfd8d9250cd1021afb545550fd7e698b623e913c26114f013"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b43bf79a894e38941f7736be15b88a0bd9def143b3e8ae6a82eeb73f0bb7c9b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3119a31eb9aaa47247c3838fc5a87917a30eb39b7244027a986951798ffeaeb"
    sha256 cellar: :any_skip_relocation, catalina:      "6e18726f0d0defa36648e0682695ff6a40a29c7db7974ab0552c8a7ae7bb0a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d8568316fade49568095cf43f6fe0c197ae5f17cf6b20d8aae337af40ad1e1" # linuxbrew-core
  end

  depends_on "rust" => :build
  # Currently needs macOS 11 SDK due to checking for DeploymentTargetSettingName
  # Remove when issue is fixed: https://github.com/indygreg/PyOxidizer/issues/431
  depends_on xcode: "12.2" if MacOS.version <= :catalina

  def install
    system "cargo", "install", *std_cargo_args(path: "pyoxidizer")
  end

  test do
    system bin/"pyoxidizer", "init-rust-project", "hello_world"
    cd "hello_world" do
      system bin/"pyoxidizer", "build"
    end
  end
end
