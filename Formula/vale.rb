class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.8.tar.gz"
  sha256 "7a01dbe5370b61a16a3126b752399174256722885946111ceea995d8cfb9e70f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1986dd9f269658d6ad06e4106ede968b1fa6c2a63e092e20a1d9ee36fe446488" => :big_sur
    sha256 "37e466ff727faf8326863f16548c1cd10ca2fc12232836dbf24e99751e2d67f2" => :catalina
    sha256 "5930b7dc78e4a216979083212dafd8b9ff18a5b327a7bb6962c40b30a6da2b08" => :mojave
    sha256 "9afccc3cd46f95224a7d1addcd9c1ba5da16dff0fc1be1622e5d6e31d8b50714" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
