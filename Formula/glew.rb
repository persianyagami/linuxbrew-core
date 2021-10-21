class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
  sha256 "d4fc82893cfb00109578d0a1a2337fb8ca335b3ceccf97b97e5cc7f08e4353e1"
  license "BSD-3-Clause"
  revision OS.mac? ? 1 : 2
  head "https://github.com/nigels-com/glew.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4ec7d501b56e5e5682f752975340c57a9aca68431d0d2cc9f849e428860f09de"
    sha256 cellar: :any, big_sur:       "9e0b9a17a4d7372d191d377ae63e6bb0070434eefc997299fe708ca12c02bfb5"
    sha256 cellar: :any, catalina:      "d3113b746275f48d4f50316c9ddf0ce27e7a11e20ffaac33dd1a2aaf9e59d52a"
    sha256 cellar: :any, mojave:        "728dbc75cee45763fcc89605d758de1ed950cf219012a1614808a6abd8883ae8"
    sha256 cellar: :any, x86_64_linux:  "0c7121cdf0692adceb4b3ec0cacefce1938e2ec54e91fab624b74245e0bc7e10" # linuxbrew-core
  end

  depends_on "cmake" => [:build, :test]

  on_linux do
    depends_on "freeglut" => :test
    depends_on "mesa-glu"
  end

  conflicts_with "root", because: "root ships its own copy of glew"

  def install
    cd "build" do
      system "cmake", "./cmake", *std_cmake_args
      system "make"
      system "make", "install"
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      project(test_glew)

      set(CMAKE_CXX_STANDARD 11)

      find_package(OpenGL REQUIRED)
      find_package(GLEW REQUIRED)

      add_executable(${PROJECT_NAME} main.cpp)
      target_link_libraries(${PROJECT_NAME} PUBLIC OpenGL::GL GLEW::GLEW)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <GL/glew.h>

      int main()
      {
        return 0;
      }
    EOS

    system "cmake", ".", "-Wno-dev"
    system "make"

    glut = "GLUT"
    on_linux do
      glut = "GL"
    end
    (testpath/"test.c").write <<~EOS
      #include <GL/glew.h>
      #include <#{glut}/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    flags = %W[-L#{lib} -lGLEW]
    on_macos do
      flags << "-framework" << "GLUT"
    end
    on_linux do
      flags << "-lglut"
    end
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    on_linux do
      # Fails in Linux CI with: freeglut (./test): failed to open display ''
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system "./test"
  end
end
