class Win12Desktop < Formula
  desc "Win12 桌面端，基于 Tauri 封装"
  homepage "https://github.com/win12-online/win12-desktop"
  license "EPL-2.0"
  version "0.2.6"

  if OS.mac?
    url "https://github.com/win12-online/win12-desktop.git",
        tag:      "v#{version}",
        revision: "067f3c8304ae4b6799fc929d5ee4385a54e86c44"

    depends_on "node" => :build
    depends_on "pnpm" => :build
    depends_on "rust" => :build
  elsif OS.linux?
    appimage_name = "Win12_#{version}_amd64.AppImage"
    url "https://github.com/win12-online/win12-desktop/releases/download/v#{version}/#{appimage_name}"
    sha256 "5539858a4f619a39033f9063f7f59e7f943fce047ab449f612d4f7e422b76085"
  end

  def install
    if OS.mac?
      unless system("xcode-select", "-p", [:out, :err] => "/dev/null")
        odie "Xcode Command Line Tools are required. Install with `xcode-select --install`."
      end

      ENV["PNPM_HOME"] = buildpath/".pnpm-home"
      system "pnpm", "config", "set", "store-dir", buildpath/".pnpm-store"
      system "pnpm", "config", "set", "cache-dir", buildpath/".pnpm-cache"

      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "exec", "tauri", "build", "--bundles", "none"

      bin.install "src-tauri/target/release/win12-desktop" => "win12"
    elsif OS.linux?
      libexec.install appimage_name => "Win12.AppImage"
      chmod 0755, libexec/"Win12.AppImage"

      (bin/"win12").write <<~EOS
        #!/bin/bash
        if command -v fusermount &>/dev/null; then
          exec "#{libexec}/Win12.AppImage" "$@"
        else
          exec "#{libexec}/Win12.AppImage" --appimage-extract-and-run "$@"
        fi
      EOS
    end
  end

  test do
    assert_predicate bin/"win12", :exist?
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
end
