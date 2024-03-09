class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.8.tar.gz"
  sha256 "baf41ca21fd2f7ab239ca27245a5e22152206db6e141cbf2329624199556f4fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bbd6ba6959b8d58d9ed958a66d9ebe02f6a1991fea9b354344ca215cce0bba02" => :big_sur
    sha256 "ae300ba99d43583e99ffbdb3bb0a5ae52da1017d16626f353807fdb340e9de71" => :catalina
    sha256 "fc4b0864a5142a8ebd91c1b4ae3195df5a1360b27d0ba939feb12a03d2286f0e" => :mojave
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
