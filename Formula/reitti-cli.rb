class ReittiCli < Formula
  desc "Agent-first command-line journey planner for the HSL service area"
  homepage "https://github.com/jarimustonen/reitti-cli"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/reitti-cli/releases/download/v1.0.0/reitti-cli-aarch64-apple-darwin.tar.xz"
    sha256 "5aa03c484152ad70e9e711c9372d39d76d715b28d34701e481289793081bdb27"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/reitti-cli/releases/download/v1.0.0/reitti-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "528c86fa641d3cabd76507fc2e922f016798eb692f3f290a35c83ef39f107c04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/reitti-cli/releases/download/v1.0.0/reitti-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4c827db56debda07e3635e610ccbdb843e15a2bb7f770e43935bf33dde26e214"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "reitti"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "reitti"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "reitti"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
