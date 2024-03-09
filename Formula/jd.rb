class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.2.0.tar.gz"
  sha256 "044a1c459b5255cce83bbfc0e8bc73ea227cf9c1c904fc3dada46f640136cbc5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "881c3988d2ff749b6b98008f025f69d377b6750b48c8fe7746830ebab26cb979" => :big_sur
    sha256 "cb706ba25f462bd0f8c32b3373022d1fe2bb9416b709c9f2b5d3d2b5c8c8bd64" => :catalina
    sha256 "a3c5ff305e4e52d31cd410dc6b88efaea8a758637cf96e997b95be2d8a049abd" => :mojave
    sha256 "5fb975f7d4bf08dc7595eecc4f186c6b0006c621594c537f8ce8fbce87886e3c" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/josephburnett/jd"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"jd"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json")
    assert_equal output, expected
  end
end
