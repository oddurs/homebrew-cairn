# Homebrew formula. Update `version` and the four sha256 values from the
# SHA256SUMS file attached to the release; everything else stays put.
class Cairn < Formula
  desc "Markdown-native roadmap and issue manager that lives in your repository"
  homepage "https://github.com/oddurs/cairn"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "e15b89d00f1a4e112680f2ca83f6e74e5410a3d04d5e35d5242a219af1e24f5e"
    end
    on_intel do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "fa2e49d21dc08b07c266f2513dd5e982fa1d7958e896a58ae208fa5657602e54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f2f89201193c620cb5859d59b26a55ae3056146ce206bdb724bdcf502de35158"
    end
    on_intel do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "39119a76e84b78a88c3f76f6e46db63ce939e32c5c9e0c8f01da5c69a049434b"
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
