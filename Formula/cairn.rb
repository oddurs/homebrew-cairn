# Homebrew formula. Update `version` and the four sha256 values from the
# SHA256SUMS file attached to the release; everything else stays put.
class Cairn < Formula
  desc "Markdown-native roadmap and issue manager that lives in your repository"
  homepage "https://github.com/oddurs/cairn"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "86db716e23d9db4ef3d6f2683877e3c436612ce5f3f013116178e28c94c3693d"
    end
    on_intel do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "d15cf525ffda912b911f07e8f1ac07ef3ef2049bee368b4f0c102b8b149cda99"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0acf5fa0e029cb9f9e1d26a7f7d9da7ab16cc6b4cb695c6e2966c466edcaea08"
    end
    on_intel do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "eb32376192f708fcdcb7e616708c852a5d56df311e71a00d686414d3e9a16c7a"
    end
  end

  def install
    bin.install "cairn"
    generate_completions_from_executable(bin/"cairn", "completions")
    # `man` writes the page to stdout, so it has to become a file before
    # Homebrew can install it: `install` takes a path, not contents.
    (buildpath/"cairn.1").write Utils.safe_popen_read(bin/"cairn", "man")
    man1.install "cairn.1"
  end

  test do
    system bin/"cairn", "--version"
    system bin/"cairn", "init", "--bare", "--name", "test"
    assert_predicate testpath/"cairn.toml", :exist?
    system bin/"cairn", "new", "A thing", "-q"
    assert_match "A thing", shell_output("#{bin}/cairn list")
  end
end
