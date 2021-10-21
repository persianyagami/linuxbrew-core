class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.7.0.tar.gz"
  sha256 "d2c101d3b6ed5a0ee1e764c749bd869a2ce8f6d5563a5e2938dc3c32ad1375c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 big_sur:      "da4483fe73a5085dd3a54034bdac7a17e12710c18ca53e90fe1386a188cb6946"
    sha256 cellar: :any,                 catalina:     "106a5e3b8ac1e69809bbd4e86733bcab971f2f35fed40a2a7197f9b57d28a039"
    sha256 cellar: :any,                 mojave:       "b5d5943589f696a3bbcdb61d0827374cd45e5903203a3e574f40bf2c19c16da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ce718fba03f900cecca4f71e34c8d0eb99750eaaeea57b2ee6388eca2b3d8d3e" # linuxbrew-core
  end

  depends_on arch: :x86_64 # dotnet does not support ARM
  depends_on "dotnet"

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase

    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec,
           "--runtime", "#{os}-x64",
           "--self-contained", "false",
           "/p:PublishSingleFile=true"

    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}" }
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
