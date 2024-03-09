class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20201217.tar.gz"
  sha256 "df6bb667c60577c89df5abe3270539c1b9716b69409d1074d6a7fc5c2fea087b"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "615e2c2548792f1620e7e0fe6e5b8232a7460b9483c66f539345b2dfbd9ff46f" => :big_sur
    sha256 "e4302dedc1720a8374d32d106fab97b4e9daf28ebacc768646b5cb62d05187ec" => :catalina
    sha256 "893420b8663ccae192b5dbe8dac8221428f17f9c862d1c3ef3e0030bb6d74c3d" => :mojave
    sha256 "b2daeea19808c8fe06133a700900c73e4ebfe8683f662276ff5938a871bd28b3" => :x86_64_linux
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
