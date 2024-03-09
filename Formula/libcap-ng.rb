class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng"
  url "https://github.com/stevegrubb/libcap-ng/archive/v0.8.tar.gz"
  sha256 "836ea8188ae7c658cdf003e62a241509dd542f3dec5bc40c603f53a5aadaa93f"
  license "LGPL-2.1-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "b80f865fba28f721976d784077aeef490582200130b2ae9ddaf5d5527c312911" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.9" => :build
  depends_on "swig" => :build
  depends_on :linux

  uses_from_macos "m4" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python3"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
  end
end
