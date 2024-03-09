class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.1",
      revision: "a78d0d41101b3b7ad10880f38498751166ae2eb3"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "83aa8c4de0377475ea7d59cc1b86a427614ab2d45e5947a4a0ef9725a10d9e62" => :big_sur
    sha256 "9492eec6728f04259ee801f6f09a3f420ba626ba02d949ca3b62aeb11429d7d3" => :catalina
    sha256 "6487891dc5aa7d5dd6748b77d6994f641e298f57aabcd33e1d5be1e4d9a1ebdf" => :mojave
    sha256 "14f272a775abca9efa2f54749865ddba7c8cffe44f899a2681995578b0fe4e45" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
