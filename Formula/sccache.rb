class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.14.tar.gz"
  sha256 "664f1557430056960261cac6f939c6d7bbd746b1e4bc88f79edcac40417bb654"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02f4a0a5af2c1c5cf446fa67ad86a535565e1d7cc84f18a596216cad4492eb68" => :big_sur
    sha256 "900c42698ed29c08b034fdeaa990fde48baf9fc608399673d99fb15ade0ba3f7" => :catalina
    sha256 "afc4e8ae1f1febbea962db840e49a89079b67af20e6058da8b302bc634c9d60b" => :mojave
    sha256 "c106c22ae082710ec8d5a69f60605d7d78c584d51ac4d83b10a36380d1d143e3" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
