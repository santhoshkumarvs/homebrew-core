class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://deb.debian.org/debian/pool/main/d/devscripts/devscripts_2.19.4.tar.xz"
  sha256 "64e8d566a133f4f62af0c27b39546cd9a86c5a6ee5cecfb8775aaeb74b1d8d18"

  bottle :unneeded

  def install
    inreplace "scripts/checkbashisms.pl" do |s|
      s.gsub! "###VERSION###", version
      s.gsub! "#!/usr/bin/perl", "#!/usr/bin/perl -T"
    end

    bin.install "scripts/checkbashisms.pl" => "checkbashisms"
    man1.install "scripts/checkbashisms.1"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh

      if [[ "home == brew" ]]; then
        echo "dog"
      fi
    EOS
    expected = <<~EOS
      (alternative test command ([[ foo ]] should be [ foo ])):
    EOS
    assert_match expected, shell_output("#{bin}/checkbashisms #{testpath}/test.sh 2>&1", 1)
  end
end
