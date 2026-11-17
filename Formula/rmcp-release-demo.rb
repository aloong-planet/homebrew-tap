class RmcpReleaseDemo < Formula
  desc "A stdio MCP server with echo and version tools"
  homepage "https://github.com/aloong-planet/rmcp-release-demo"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aloong-planet/rmcp-release-demo/releases/download/v0.1.0/rmcp-release-demo-aarch64-apple-darwin.tar.xz"
    sha256 "8966ffcd6bd2dc6b27fdd1c1ce4756559c62ca673147df9e3f77b2aa12b7dd66"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aloong-planet/rmcp-release-demo/releases/download/v0.1.0/rmcp-release-demo-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3f5e02aca627239f62918b26e652d40e621882539dff3c75ac0305ca26bbd3d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aloong-planet/rmcp-release-demo/releases/download/v0.1.0/rmcp-release-demo-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3797385d3aaf2be839cc7b2f5f46d3a08bf7d8333ddedd5ec7de86f1a5d9220a"
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
      bin.install "rmcp-release-demo"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rmcp-release-demo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rmcp-release-demo"
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
