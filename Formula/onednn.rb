class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.4.1.tar.gz"
  sha256 "930a2327c4fe4018a604f67ca3c0ebea01436aad7ce1f4e01d088732bd19d16f"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1ab17cda20f0f054e9044b38640cc36e21e5a5f0cbc561c3c453c6a426cd0690"
    sha256 cellar: :any,                 big_sur:       "87190071798f200822a37d47ce82747b47b512c41858a36058c7430be5937ad0"
    sha256 cellar: :any,                 catalina:      "279d477fea9a61fcc5d61a1d35c6c3b541ceb9f78bafe4306ad36a4bb41e26f4"
    sha256 cellar: :any,                 mojave:        "2e0856dd5923603cecd829b4a9f02a02b15a48f186873b09ae03b0272a4a8413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6811f4c468f7f5e87ae3d0cbcd751680dc1753ceeab67f5bc57721bd570035" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
