class Win12Dektop < Formula
  desc "Win12 桌面端，基于 Tauri 封装，将 Win12 网页版变成独立桌面应用。"
  homepage "https://github.com/win12-online/win12-desktop"
  license "EPL-2.0"

  if OS.mac?
    url "https://github.com/win12-online/win12-desktop.git",
        tag:   "v0.2.6",
        using: :git

    depends_on "node" => :build
    depends_on "pnpm" => :build
    depends_on "rust" => :build
  elsif OS.linux?
    url "https://github.com/win12-online/win12-desktop/releases/download/v0.2.6/Win12_0.2.6_amd64.AppImage"
    sha256 "5539858a4f619a39033f9063f7f59e7f943fce047ab449f612d4f7e422b76085"
  end

  def install
    if OS.mac?
      arch = Hardware::CPU.arm? ? "aarch64-apple-darwin" : "x86_64-apple-darwin"
      system "rustup", "target", "add", arch if which("rustup")

      pnpm_store = buildpath/".pnpm-store"
      pnpm_cache = buildpath/".pnpm-cache"
      ENV["PNPM_HOME"] = buildpath/".pnpm-home"
      
      system "pnpm", "config", "set", "store-dir", pnpm_store
      system "pnpm", "config", "set", "cache-dir", pnpm_cache
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "exec", "tauri", "build", "--bundles", "none", "--target", arch

      bin.install "src-tauri/target/#{arch}/release/Win12"
    elsif OS.linux?
      libexec.install "Win12_0.2.6_amd64.AppImage" => "Win12.AppImage"

      (bin/"Win12").write <<~EOS
        #!/bin/bash
        exec "#{libexec}/Win12.AppImage" "$@"
      EOS
    end
  end
