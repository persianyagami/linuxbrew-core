class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage "https://foremost.sourceforge.io/"
  url "https://foremost.sourceforge.io/pkg/foremost-1.5.7.tar.gz"
  sha256 "502054ef212e3d90b292e99c7f7ac91f89f024720cd5a7e7680c3d1901ef5f34"
  license :public_domain

  livecheck do
    url "http://foremost.sourceforge.net/"
    strategy :page_match
    regex(/href=.*?foremost[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "c8f1ad7327f5cc999d9c54486bfcf2a1c6ab4ff3e76b455b3ba79f930befba14" => :big_sur
    sha256 "9ccac7b43068a6c89c5b48b33af7bfac09ab7e69fb36b1376e79646c6a01f049" => :catalina
    sha256 "a552aed53b1ca671b4c23e0dd61ce2e82ea09a0c2798615a6a44860475aeaea7" => :mojave
    sha256 "c5f0d5078dff8e5f05665710ef8c297630990d806cb4426d74b31a6bceae31aa" => :x86_64_linux
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.gsub! /^RAW_FLAGS =/, "RAW_FLAGS = #{ENV.cflags}"
    end

    if OS.mac?
      system "make", "mac"
    else
      inreplace "config.c", "/usr/local/etc/", "#{etc}/"
      system "make"
    end

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.default"
  end

  test do
    system "#{bin}/foremost", "-V"
  end
end
