# niri-macos-desktop

为 **Arch Linux + Niri** 打造的 macOS Sonoma / Sequoia 风格桌面配置起始套件。项目结合半透明风格的 Waybar 顶部菜单栏、可选 Dock 启动器，以及由 **Walker + Elephant** 提供的 Spotlight 风格搜索体验。

> **项目状态：** 本项目提供配置示例和起始脚本，尚未在你的实际设备上进行测试。软件包可用性、上游命令行参数和配置格式都可能变化；请先在本机验证，再将其用于日常桌面环境。

## 功能特性

- 使用 Waybar 显示 Niri 工作区、当前聚焦窗口、音频、网络和时钟。
- 使用 Walker 作为搜索界面，并通过 Elephant 调用各类搜索提供器。
- 在现有 Niri 快捷键配置中添加绑定后，可通过 **Super + Space** 打开 Walker。
- 可选的 Elephant 提供器：桌面应用、计算器、文件搜索、命令运行器、网页搜索和剪贴板历史。
- 安装脚本会备份要替换的 Waybar 配置文件，避免静默覆盖原文件。
- 提供可选的 Dock 启动脚本，并说明 Niri 环境下的相关限制。
- 提供中文输入法（Fcitx5 / 拼音）、中日韩字体、中文区域设置和剪贴板历史的配置指南。

## 仓库结构

- `install.sh`：安装 Arch Linux 软件包，并复制项目配置；覆盖前会创建带时间戳的备份。
- `waybar/`：Waybar 的 JSONC 配置和 CSS 样式。
- `niri/config.kdl.example`：快捷键和启动方式示例，**不是完整的 Niri 配置文件**。
- `walker/`：Walker 配置与主题说明。
- `elephant/`：Elephant 服务和提供器的配置说明。
- `scripts/start-dock`：可选的 nwg-dock 启动脚本。
- `docs/`：安装、兼容性和故障排查文档，包括[中文输入法与区域设置](docs/ime-chinese.md)以及[剪贴板历史配置](docs/clipboard-history.md)。

## 安装

### 1. 克隆仓库

```bash
git clone https://github.com/jerryliuxa/niri-macos-desktop.git
cd niri-macos-desktop
```

### 2. 安装软件包并复制 Waybar 配置

安装脚本面向 Arch Linux，需要使用 `pacman`；安装 Walker、Elephant 及其提供器时，还需要安装并配置 `yay` 或 `paru` 等 AUR 助手。

```bash
chmod +x install.sh scripts/start-dock
./install.sh
```

脚本会将被替换的文件备份到 `~/.config/niri-macos-desktop-backups/`。它**不会替换** `~/.config/niri/config.kdl`。

### 3. 安装并启用 Elephant

常用的 AUR 软件包包括：

```bash
yay -S --needed walker elephant elephant-providerlist elephant-desktopapplications elephant-calc elephant-files elephant-runner elephant-websearch
```

启用并启动用户服务：

```bash
elephant service enable
systemctl --user enable --now elephant.service
```

检查提供器列表和服务状态：

```bash
elephant providers list
systemctl --user status elephant.service
```

首次运行 Walker，以生成默认配置和主题目录：

```bash
walker
```

> 上游命令、软件包名称或服务管理方式可能随版本变化。如果某条命令不可用，请以当前版本的项目文档为准。

### 4. 配置 Niri 快捷键

编辑 `~/.config/niri/config.kdl`，将下面这行添加到**已有的** `binds { ... }` 配置块中：

```kdl
Mod+Space { spawn "walker"; }
```

不要不加检查就重复创建第二个 `binds` 配置块，也不要直接用示例文件覆盖完整的 Niri 配置。如果这个快捷键已经被占用，请换成其他组合键。

检查配置是否有效：

```bash
niri validate
```

### 5. 启动 Waybar

安装脚本会将文件复制到 `~/.config/waybar/`。可以使用以下命令重启 Waybar：

```bash
pkill waybar 2>/dev/null || true
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"
```

如果 Waybar 尚未由当前会话或自动启动机制启动，可在 Niri 配置的顶层添加：

```kdl
spawn-at-startup "waybar"
```

如果你的会话已经会自动启动 Waybar，请勿重复添加。

## 剪贴板历史（可选）

安装可选的剪贴板提供器：

```bash
yay -S --needed elephant-clipboard
systemctl --user restart elephant.service
elephant providers list
```

按 **Super + Space** 打开 Walker，然后输入 `:` 和搜索词，即可搜索剪贴板历史。

如果希望使用专用快捷键，可将下面这行加入现有的 Niri `binds { ... }` 配置块：

```kdl
Mod+V { spawn "walker"; }
```

此快捷键只会打开 Walker，**不会自动输入 `:` 前缀**；打开后仍需手动输入 `:` 和搜索词。

**隐私提醒：** 剪贴板历史可能保存密码、API 密钥、访问令牌、私人消息及其他敏感内容。使用前请检查所安装版本的保留策略和隐私设置。更多信息与故障排查见[剪贴板历史指南](docs/clipboard-history.md)。

## 中文输入法与中文界面

中文输入、字体覆盖和桌面区域设置是相互独立的配置。请参考[中文输入法与区域设置指南](docs/ime-chinese.md)，按需配置 Fcitx5 / 拼音、环境变量、Niri 启动项、中日韩字体，以及可选的简体中文区域设置。

该指南为可选步骤，**不会由 `install.sh` 自动执行**。

## Walker 基本用法

- 输入应用名称，然后按 Enter 启动应用。
- 使用方向键选择结果，按 Escape 关闭搜索界面。
- 各提供器支持的搜索前缀可能不同，请查看当前 Walker 文档。
- 计算器、文件、网页搜索、剪贴板和命令运行器等结果，只有在对应的 Elephant 提供器已安装且正常工作时才会显示。

## 关于 Dock 的说明

`scripts/start-dock` 是基于 nwg-dock 的可选实验功能，不是 Walker 或 Waybar 正常工作的必要条件。

请阅读 [Dock 功能限制说明](docs/dock-limitations.md)。在 Niri 环境中，通用 Dock 可能无法完整实现 macOS 式的运行中应用指示器、图标放大动画或可靠的自动隐藏行为。实际效果取决于 Dock 实现、Niri 及相关组件的版本。

## 安全提示与备份

- 运行脚本前，请先阅读并理解脚本内容。
- 安装脚本会为项目管理的 Waybar 文件创建带时间戳的备份。
- 安装脚本不会修改 Niri 主配置；快捷键示例需要手动合并。
- 剪贴板历史可能保留私人文本。请先了解提供器的行为，再决定是否启用。
- 最终视觉效果会受到 GTK 主题、图标主题、字体、显示缩放比例和显示器布局等因素影响。

## 上游项目与文档

- Walker 文档：https://walkerlauncher.com/docs/
- Walker 提供器文档：https://walkerlauncher.com/docs/providers
- Walker 源码：https://github.com/abenz1267/walker
- Elephant 源码：https://github.com/abenz1267/elephant
- Niri 配置与源码：https://github.com/niri-wm/niri
- Waybar 源码：https://github.com/Alexays/Waybar
