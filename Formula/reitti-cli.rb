class ReittiCli < Formula
  desc "Agent-first command-line journey planner for the HSL service area"
  homepage "https://github.com/jarimustonen/reitti-cli"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/reitti-cli/releases/download/v1.1.0/reitti-cli-aarch64-apple-darwin.tar.xz"
    sha256 "45ef8ec867916b04154bfb8b5c7e67a901ee4b263b42efc4162d4238ac99ad8a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/reitti-cli/releases/download/v1.1.0/reitti-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "879d82cc8cec1a0251a7d2aef854b5bd02074c8b5e4688892724247f01f60234"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/reitti-cli/releases/download/v1.1.0/reitti-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e4493a102f1d2bcd80ed9e3b4756b4219ac5c30fd8d370e822d529a32bcec107"
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
