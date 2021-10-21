class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  revision 2
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  stable do
    url "https://github.com/HaxeFoundation/haxe.git",
        tag:      "4.2.3",
        revision: "1385eda48e60387e349282d26347b28d0b2768ca"

    # Remove when campl5 dependency is bumped to 8.00 in a release
    patch do
      url "https://github.com/HaxeFoundation/haxe/commit/db72b31390c51c1627cf5658ca256aace41a81b0.patch?full_index=1"
      sha256 "95a22f2cc227c4e6d066e60eb88b2a71ad6c278d6f38656fbd87ee905411918a"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "982600fa3892cbd4ef0d2597b9400499bcf820d7866b188fcd048b8a483b5bb6"
    sha256 cellar: :any,                 big_sur:       "69541c84de5f7a89565c1b0db59742801d56d7b92717d3ff4f129ec0099ef055"
    sha256 cellar: :any,                 catalina:      "73cd847047274cb23a0b23e47ce091145c8eaf5131ad298e0195005f4ec6ee03"
    sha256 cellar: :any,                 mojave:        "bce0544534411a2f7c53a66114a5c9e4e681e44ad9b9903fa6ddf757757721fd"
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"
  depends_on "neko"
  depends_on "pcre"

  uses_from_macos "m4" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "node" => :test
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "IPC::System::Simple" do
    url "https://cpan.metacpan.org/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["ADD_REVISION"] = "1" if build.head?
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "exec", "--", "opam", "pin", "add", "haxe", buildpath, "--no-action"
      system "opam", "exec", "--", "opam", "install", "haxe", "--deps-only", "--working-dir", "--no-depexts"
      system "opam", "exec", "--", "make"
    end

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}/haxe", "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
    system "#{bin}/haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system "#{bin}/haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = "osascript -so -lJavaScript out.js 2>&1"
    on_linux do
      cmd = "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end
