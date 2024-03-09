class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.9.tar.gz"
  sha256 "66f998d425631673af2772bc4ebafa55f4d74224cbd99bd5570bba53d50be27a"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a4cd57e06f4c092beb60277b9d909d62197b7515af3d68247b30847e365f98" => :big_sur
    sha256 "5e41b0c9d4bd8147ebb01cafad88c2d505fffc7bac5d85de44eb5429c317c06c" => :catalina
    sha256 "52ca84fda5684a60c3d40a4fe398cb5be90b4331f11c9f90e833a7e7af49237f" => :mojave
    sha256 "18a4c1ae77f2c71883a9c9fa397a1e12db88248b77a416026dfbfbc2155e5c84" => :x86_64_linux
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    return if !OS.mac? && ENV["CI"]

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
