class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.63.tgz"
  sha256 "7eddd53401b99b90bac3f7ebf23dd583d7d99c6106e67a4f1161b7a20110dc6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dcd1fba2f36a3a67c68f97de8f8d350cfd04e20b2874889815520d2cc166432" => :big_sur
    sha256 "37acc6e39f2eb62773e13bb1a75f41f5c451227f6da2991e8c741806070f1628" => :arm64_big_sur
    sha256 "056ed50b34a51b0f86dd9aad74785dc956e204621faa7c0ee4535e4bb54dfdfb" => :catalina
    sha256 "ccdff1c449f1d218ae636de168f9f36fdc1fd8aee3dd71c83ad4d562c7cd4567" => :mojave
    sha256 "aa3691a218fb3b34065729e648dbf4339150de2247f48c458832fba6221ca509" => :high_sierra
    sha256 "d3e8ca3a4acd3bc5ec87bacb4eb49701e72cec0c80da5a1a8cf69560a0bd9117" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<~EOS
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 '7eddd53401b99b90bac3f7ebf23dd583d7d99c6106e67a4f1161b7a20110dc6f'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
