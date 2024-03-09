class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  license "GPL-2.0"
  revision 1 unless OS.mac?

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aacf573a663f8c555bfa8163593386046462856392001b9dcad317fcf889fdfe" => :big_sur
    sha256 "a95b3272a26918e1a92ad548ca72e1b74f5ade8073193c560c418369f9dacb51" => :arm64_big_sur
    sha256 "853b0f355c1bb6bdfc41d2ad17026d75c93aecb7581e711d7db3edab4ca6b5d4" => :catalina
    sha256 "52ccb5bfce1cda123f30c84335172335cee0706973e6769ec9a5358cb160f364" => :mojave
    sha256 "7924c9c7dc7b3eee0056171df8c6b66c2e0e8888e4638232e967a5ea31ca5b86" => :high_sierra
    sha256 "e587e46b6ebdebb7864eb4f9cb17c221024d9167ae0148899adedb6127b2bdfb" => :sierra
    sha256 "14bb0680842b8b392cb1a5f5baf142e99a54a538d1a587f6d1158785b276ffc6" => :el_capitan
    sha256 "da6c24f1cc40fdf6ae286ec003ecd779d0f866fe850e36f5e5953786fa45a561" => :yosemite
    sha256 "5deeef3625d52f71d633e7510396d0028ec7b7ccf40c78b5d254bdf4214e6363" => :mavericks
    sha256 "250734ea7e79dec10ea7914695614b9a5b5604dde1ccc2488663258bab5c10eb" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "expat"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    unless OS.mac?
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    unless OS.mac?
      Dir[bin/"intltool-*"].each do |f|
        inreplace f, %r{^#!/.*/perl -w}, "#!/usr/bin/env perl"
        inreplace f, /^(use strict;)/, "\\1\nuse warnings;"
      end
    end
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
