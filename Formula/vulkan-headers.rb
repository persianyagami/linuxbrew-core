class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.165.tar.gz"
  sha256 "3f9435a93ba13d94d0c3265a47e0436579e46bb9ca085e9b16a753458e4d79d2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "74e707c9105079fef9dc008c38fe6fbaa9d848798f831b124256839158dfa2a6" => :big_sur
    sha256 "686d6a6610fc754ddf2cb10496da6e1bc813bf36e620b9144eba3673deef116b" => :arm64_big_sur
    sha256 "1b911322c6c3b3cc50c1c1013d5a982dcbbaa04f78139326fd50bc1a1f00bb6f" => :catalina
    sha256 "8c17d20b1a4ab67c4cbe44f85bf2be714a2c922aa6e9be92b9b4b3e9d4ad2664" => :mojave
    sha256 "f09de3797bd12508a996c03c7303cfa83f4480bac375499d3d32daa7b0566f61" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
