class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.14.0/nifi-registry-1.14.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.14.0/nifi-registry-1.14.0-bin.tar.gz"
  sha256 "4fac3cab66e0e2eba7d9f7bed27f3783942e01e67c79bba404309bbf9b5262a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f7fcf5331d09893e9cef3554a932904f83b07521d650a6538c2326a5f3d347eb" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/",
                             Language::Java.overridable_java_home_env.merge(NIFI_REGISTRY_HOME: libexec)
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
