# Win12 Desktop Homebrew Tap

![Win12 Desktop](https://img.shields.io/badge/Win12-Desktop-0078d4?style=flat-square)
[![EPL-2.0](https://img.shields.io/badge/license-EPL--2.0-2ea44f?style=flat-square)](./LICENSE)

Win12 Desktop 的 [Homebrew](https://github.com/homebrew/brew) 安装仓库。Win12 Desktop 基于 Tauri 封装，将
[Win12 Online](https://github.com/win12-online/win12) 变成可独立运行的桌面应用。

> 本仓库只维护 Homebrew formula，不包含 Win12 Desktop 的应用源码。

## 项目链接

- [Win12 Online](https://github.com/win12-online/win12)：网页版项目
- [Win12 Desktop](https://github.com/win12-online/win12-desktop)：桌面端源码、发布版本与开发文档
- [在线体验](https://win12-online.github.io/win12/boot.html)

## 安装

### macOS

```bash
brew tap freedom-323/win12-desktop
brew install win12-desktop
```

安装完成后，在终端运行：

```bash
win12
```

macOS 安装过程会从 Win12 Desktop 源码构建应用，因此需要 Xcode Command Line Tools。
Formula 会自动使用 Homebrew 安装的 Node.js、pnpm 和 Rust 构建依赖。

### Linux

当前 Linux formula 提供 `x86_64` AppImage：

```bash
brew tap freedom-323/win12-desktop
brew install win12-desktop
```

安装完成后运行：

```bash
win12
```

如果系统没有 `fusermount`，启动脚本会自动使用 AppImage 的
`--appimage-extract-and-run` 模式。

> Windows 不属于 Homebrew formula 的目标平台。Windows 用户请前往
> [Win12 Desktop Releases](https://github.com/win12-online/win12-desktop/releases)
> 下载对应安装包。

## 升级与卸载

升级 formula：

```bash
brew update
brew upgrade win12-desktop
```

卸载：

```bash
brew uninstall win12-desktop
brew untap freedom-323/win12-desktop
```

## Formula 维护

Formula 位于 [`Formula/win12-desktop.rb`](./Formula/win12-desktop.rb)，当前跟踪
Win12 Desktop `v0.2.7`。

更新版本时需要同步检查：

1. `version`、源码 tag 或 Linux AppImage 下载地址；
2. Linux AppImage 的 `sha256`；
3. macOS 源码构建所需的 revision；
4. `brew install --build-from-source win12-desktop` 和基础 smoke test。

本地检查 formula：

```bash
brew audit --formula Formula/win12-desktop.rb
brew style Formula/win12-desktop.rb
```

## 免责声明

Win12 Desktop 是一个非商业性的开源兴趣项目，与 Microsoft Corporation
及其关联实体没有隶属、赞助、授权或认可关系。“Windows”和相关商标归其各自
权利人所有。本项目仅用于学习、研究与技术展示，请遵守适用的法律法规及第三方
许可条款。

## 许可证

本仓库采用
[Eclipse Public License 2.0](./LICENSE) 发布。
