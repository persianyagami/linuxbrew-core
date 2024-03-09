require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.0.tgz"
  sha256 "52aa3e5da229d84e20e25ccb1715dde151687b2b31da4bd28deb39ae30002129"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a71a4c107577dd6b0ab7f14c199af43d90944578d4372c10ccf7036aab3178" => :big_sur
    sha256 "53d34dc29f75811bde029f6e1c671c7c44a1d355e3d543c51e37b2465ecf5f86" => :catalina
    sha256 "41b35a77fc32bc186b0c250744548c02fe2afc9edfe88b4089ed96226899f0a3" => :mojave
    sha256 "99bd054b107f4ded36bfca31e64f42d909d99896abdea374bd256207e17c0368" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
