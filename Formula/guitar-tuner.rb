class GuitarTuner < Formula
  desc "Terminal guitar tuner for USB amps, audio interfaces and microphones"
  homepage "https://github.com/jmoro0408/guitar-tuner"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jmoro0408/guitar-tuner/releases/download/v0.1.0/guitar-tuner-aarch64-apple-darwin.tar.xz"
      sha256 "862abcc5dda54e7af55a919f1e6f5e98242bd8f15dece339249246a1e7b37247"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jmoro0408/guitar-tuner/releases/download/v0.1.0/guitar-tuner-x86_64-apple-darwin.tar.xz"
      sha256 "a2f277debf0b4ed669a0600965ea02ac12f0532fba4e9dda43e49162faccb14a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jmoro0408/guitar-tuner/releases/download/v0.1.0/guitar-tuner-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f03b8b28d0c68ebdd223a9657233571e5bda70bc73073bf37d38289a8454195f"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "guitar-tuner"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "guitar-tuner"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "guitar-tuner"
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
