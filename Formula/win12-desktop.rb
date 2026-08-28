class Win12Desktop < Formula
  desc "Win12 桌面端，基于 Tauri 封装，将 Win12 网页版变成独立桌面应用"
  homepage "https://github.com/win12-online/win12-desktop"
  license "EPL-2.0"
  
  if OS.mac?
    url "https://github.com/win12-online/win12-desktop.git",
        tag:      "v0.2.6",
        revision: "067f3c8304ae4b6799fc929d5ee4385a54e86c44"
    
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
      
      # 如果系统有 rustup，添加对应的目标架构
      system "rustup", "target", "add", arch if which("rustup")
      
      # 配置 pnpm 独立环境变量路径
      ENV["PNPM_HOME"] = buildpath/".pnpm-home"
      system "pnpm", "config", "set", "store-dir", buildpath/".pnpm-store"
      system "pnpm", "config", "set", "cache-dir", buildpath/".pnpm-cache"
      
      # 执行前端与 Tauri 编译
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "exec", "tauri", "build", "--bundles", "none", "--target", arch
      
      # 定位并安装编译完成的二进制文件
      target_dir = Hardware::CPU.arm? ? "src-tauri/target/aarch64-apple-darwin/release" : "src-tauri/target/release"
      bin.install "#{target_dir}/win12-desktop" => "win12"
      
    elsif OS.linux?
      # 将 AppImage 移动到 libexec 目录并赋予执行权限
      libexec.install "Win12_0.2.6_amd64.AppImage" => "Win12.AppImage"
      chmod 0755, libexec/"Win12.AppImage"
      
      # 创建可执行的 Shell 包装脚本
      (bin/"win12").write <<~EOS
        #!/bin/bash
        exec "#{libexec}/Win12.AppImage" "$@"
      EOS
    end
  end

  test do
    assert_match "v0.2.6", shell_output("#{bin}/win12 --version", 2)
  end
end

