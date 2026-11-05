class Win12Desktop < Formula
  desc "Win12 Desktop"
  homepage "https://github.com/win12-online/win12-desktop"
  version "0.3.3"  # ***
  license "EPL-2.0"

  if OS.mac?
    url "https://github.com/win12-online/win12-desktop.git",
        tag:      "v#{version}",
        revision: "ce79e03e27f609f6f56059facb0fe5f1ff7821aa"  # ***

    depends_on "node" => :build
    depends_on "pnpm" => :build
    depends_on "rust" => :build
  elsif OS.linux?
    url "https://github.com/win12-online/win12-desktop/releases/download/v#{version}/Win12_#{version}_amd64.AppImage"
    sha256 "596c1095381a3cace777b956f1061f0dc6335bc5dd6df33673753c29c622b5c7"  # ***
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
      appimage_name = "Win12_#{version}_amd64.AppImage"
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
    assert_predicate bin/"win12", :executable?
  end

  livecheck do
    url :homepage
    strategy :github_latest
  end
end
