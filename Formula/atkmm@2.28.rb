class AtkmmAT228 < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.1.tar.xz"
  sha256 "116876604770641a450e39c1f50302884848ce9cc48d43c5dc8e8efc31f31bad"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "ef1b7d9dc9fd11bc07199b54078619fb68d78b8bbcf7a6335ccebc28a4ae215a" => :big_sur
    sha256 "750b50b9da2bf48ce5e69b0fbaf09e87183e5c0bd79fb2d3574e23e9fa8c7e6e" => :catalina
    sha256 "5d3a7b3bed2ee8da8a8152138db15aa461aee925c3a2eba5b83b3da8bfea6c84" => :mojave
    sha256 "e5bce7ff3d7f8d267dc992461a4da622b9474a080d6702c45e75e856e9d270d8" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm@2.64"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    EOS
    atk = Formula["atk"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm@2.64"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
      -I#{lib}/atkmm-1.6/include
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-1.6
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
