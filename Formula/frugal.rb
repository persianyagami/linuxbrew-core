class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.12.2.tar.gz"
  sha256 "f8b9d73c55011410bcf5b628b5b02bdeb5d777983f8954631044397239fc2a5e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c4caaa353cd4ed5fe965bdf7a7bc2dd7f3c43b683dabb1124357e5422e9b46b" => :big_sur
    sha256 "0874d2902cb67023e16cb544c1c9e3b1d9d4292b672689ae614b817f64c3be71" => :catalina
    sha256 "f0a6759c72da310d4377b865cf017e8c27bcfc74aa3e364370ddb76f08e2b904" => :mojave
    sha256 "04bc69974768e71ae7d6d6f01349cb396ba2c1b4b739db69c65ee635e586bd0e" => :x86_64_linux
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
