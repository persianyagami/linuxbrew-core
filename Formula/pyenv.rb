class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.21.tar.gz"
  sha256 "a36f11a9e35bb3354e820fe2e9d258208624703506878fc6b7466d646b59d782"
  license "MIT"
  version_scheme 1
  revision 1 unless OS.mac?
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "e31e42f7e32997c86bc4eb5882a330d162b674e2c8304ea33d2bdef1467ccb4f" => :big_sur
    sha256 "7b856b081f23c189584854d49a0b4b40421af54f92ce520839c13f90f4d7dcad" => :arm64_big_sur
    sha256 "2f4c78fd8cce10de8e9fb48a43c7cd51003e7a87c3cba9e4c3942d72f331df58" => :catalina
    sha256 "a3f8395adbc0644940fa03f41807fac246b997d10ae990f549e016699a2b7e51" => :mojave
    sha256 "d4a573a9116ee1f474e4a77517af5c9dfaefe5ebb9cf7f26d2cc9ac872fe1155" => :high_sierra
    sha256 "69854bb635ae0147e0da9facfdbd4e7aa270af917f1055ef4592e9a206237475" => :x86_64_linux
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"
  depends_on "python@3.9" unless OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-versions", "system pyenv-which python", "system pyenv-which python3"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
