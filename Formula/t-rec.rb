class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.3.1.tar.gz"
  sha256 "aac0d1cc10d00295b089bc75b90987d0e92d5a371367fff57970abaef60a4136"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbcb07617527b300131eef20b2146f9122fe547b611cbf1b1ef35b4a36484120" => :big_sur
    sha256 "59b687bbdebebdec22b2c6b71993e71d6f2bc9d0c91ef0b78c7ec14e98e78a80" => :catalina
    sha256 "73f405fa2311aeef26f0ce46ec77fca484b281cbeff48bb3430d3e3b143096f5" => :mojave
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # let's fetch the window id
    o = shell_output("#{bin}/t-rec -l | tail -1").strip
    win_id = o.split(/\s|\n/)[-1]
    # verify that it's an appropriate id
    assert_equal win_id && Integer(win_id).positive?, true

    # verify also error behaviour, as suggested
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
  end
end
