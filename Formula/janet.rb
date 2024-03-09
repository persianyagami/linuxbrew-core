class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.13.1.tar.gz"
  sha256 "7d369b72a1fc649f7e5c254e2b746eb36885970504f6d9d3441507ca2d716644"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "b282a98cfed34a5a4d5b30742b0fdc91a65ef2bdf9ac9baf8eadc9f9a5af9322" => :big_sur
    sha256 "a63bbdac0dcbf8f16679ea086ef4ddabbb95c59369145096f38e2b11c1aca0f6" => :catalina
    sha256 "8bc582ff4cc25fa96bcff5b862d90e08c5d135982938674ad6877c2a55f63016" => :mojave
    sha256 "28d9b56e0e2e4d4a25c1c302489322b91daa7915f1c5e44f02b89717c1e446c8" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
