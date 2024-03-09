class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-12-21",
       revision: "5e2935e0b3bdcfaf95b4b5f86d4a0c4aec7588f5"
  version "2020-12-21"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf1ca044c6683c8eaec18ab5af44f62fff22003979c369e47d8b43773c28b37d" => :big_sur
    sha256 "46655a896e916fe30e299ccf09985fce3e0ee24c90fa5d83083025f496284f5d" => :catalina
    sha256 "7c384905a810f88a7610fb7eeee844855df63a4695b73b468bbd8d834adea91c" => :mojave
    sha256 "b268453ed982cf09e6a5acae0f4ccbff54ba170ebfcb606e7ccf2b2efeab70dd" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
