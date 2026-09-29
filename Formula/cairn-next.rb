# Cairn's 1.x pre-release line, which writes format 5, beside the stable
# `cairn`. Harrow 0.2 is paired with it. When Cairn 1.0.0 is released, plain
# `cairn` moves to the 1.x line and this formula is retired.
#
# Update `version` and the four sha256 values from the SHA256SUMS file attached
# to the release; everything else stays put.
class CairnNext < Formula
  desc "Markdown-native roadmap and issue manager that lives in your repository"
  homepage "https://github.com/oddurs/cairn"
  version "1.0.0-alpha.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "c5dda05c57392bf67909b6262a146809926a41301e1cfd4e180821c464a66b05"
    end
    on_intel do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "92b83956e1a4fea6422091b9e46123b0b94021ecc7fe574a53a54b2583dfffff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7dda0666f4f0d463a81992d8b0e305b4a302bab662dac15dc42bb16c725f4741"
    end
    on_intel do
      url "https://github.com/oddurs/cairn/releases/download/v#{version}/cairn-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "751e02c386b22ad287c8120d51204815349669e239909b53c92cf1e552d10337"
    end
  end

  # Not `cairn@1`: Homebrew makes a versioned formula keg-only, and the point
  # of installing this is a `cairn` on PATH, which Harrow runs for every write.
  conflicts_with "cairn", because: "both install a `cairn` binary"

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
    assert_path_exists testpath/"cairn.toml"
    system bin/"cairn", "new", "A thing", "-q"
    assert_match "A thing", shell_output("#{bin}/cairn list")
  end
end
