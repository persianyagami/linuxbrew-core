class MysqlAT56 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.6/en/"
  url "https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.50.tar.gz"
  sha256 "efc48d8160a66b50fc498bb42ea730c3b6f30f036b709a7070d356edd645923e"
  license "GPL-2.0-only"

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/5.6.html?tpl=files&os=src&version=5.6"
    regex(/href=.*?mysql[._-]v?(5\.6(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 "4682d77e9e07fbada76340fe5101163373ecca62619beced780c053516228019" => :big_sur
    sha256 "3d25ca89293a7e4e4ac702f4494815c343a610fda7c23334ef55ecf98345b05b" => :catalina
    sha256 "8c2dcd492f329bfe298725920ed9db5c73858b7af6df393bf358ab133a9deac1" => :mojave
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "libedit" unless OS.mac?

  def datadir
    var/"mysql"
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DWITH_EDITLINE=system
      -DWITH_NUMA=OFF
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITH_EMBEDDED_SERVER=ON
      -DWITH_ARCHIVE_STORAGE_ENGINE=1
      -DWITH_BLACKHOLE_STORAGE_ENGINE=1
      -DENABLED_LOCAL_INFILE=1
      -DWITH_INNODB_MEMCACHED=ON
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

    # Avoid references to the Homebrew shims directory
    os = OS.mac? ? "mac" : "linux"
    inreplace bin/"mysqlbug", HOMEBREW_SHIMS_PATH/"#{os}/super/", ""

    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
    end

    # Remove the tests directory
    rm_rf prefix/"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"

    # Fix up the control script and link into bin.
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    libexec.install bin/"mysqlaccess"
    libexec.install bin/"mysqlaccess.conf"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    return if ENV["CI"]

    # Make sure the datadir exists
    datadir.mkpath
    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    <<~EOS
      A "/etc/my.cnf" from another install may interfere with a Homebrew-built
      server starting up correctly.

      MySQL is configured to only allow connections from localhost by default

      To connect:
          mysql -uroot
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/mysql@5.6/bin/mysql.server start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/mysqld_safe</string>
          <string>--datadir=#{datadir}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{datadir}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    # Expects datadir to be a completely clean dir, which testpath isn't.
    dir = Dir.mktmpdir
    system bin/"mysql_install_db", "--user=#{ENV["USER"]}",
    "--basedir=#{prefix}", "--datadir=#{dir}", "--tmpdir=#{dir}"

    port = free_port
    pid = fork do
      exec bin/"mysqld", "--datadir=#{dir}", "--port=#{port}"
    end
    sleep 2

    output = shell_output("curl 127.0.0.1:#{port}")
    output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
    assert_match version.to_s, output
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
