# Chinese input method and Chinese UI on Arch Linux + Niri

This guide adds Chinese input and locale/font support to the macOS-inspired Niri setup. It is optional and intentionally separate from `install.sh`, so users who do not need Chinese input do not install extra packages.

## 1. Install Fcitx5 and CJK fonts

For Pinyin input:

```bash
sudo pacman -S --needed \
  fcitx5 \
  fcitx5-chinese-addons \
  fcitx5-gtk \
  fcitx5-qt \
  fcitx5-configtool \
  noto-fonts-cjk \
  noto-fonts-emoji
```

`fcitx5-chinese-addons` provides Pinyin-related input engines. If you prefer Rime, install and configure `fcitx5-rime` instead; Rime dictionaries and schema selection are separate configuration steps.

## 2. Configure environment variables

Create the environment file:

```bash
mkdir -p ~/.config/environment.d
cat > ~/.config/environment.d/90-fcitx5.conf <<'EOF'
QT_IM_MODULE=fcitx
QT_IM_MODULES=wayland;fcitx
XMODIFIERS=@im=fcitx
EOF
```

These variables are read by systemd user sessions and may not affect applications that were already running. Native Wayland GTK applications often work without forcing `GTK_IM_MODULE`; avoid setting it globally unless you have a specific compatibility issue.

For GTK3 applications running through XWayland, an optional compatibility setting is:

```bash
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<'EOF'
[Settings]
gtk-im-module=fcitx
EOF
```

If this setting causes problems in a particular application, remove it and test again.

## 3. Start Fcitx5 from Niri

Add the following at the top level of `~/.config/niri/config.kdl` (not inside `binds { ... }`) if Fcitx5 is not already autostarted:

```kdl
spawn-at-startup "fcitx5" "-d" "--replace"
```

Do not add a duplicate startup entry if your desktop session already starts Fcitx5. You can test it immediately with:

```bash
fcitx5 -d --replace
```

Then log out and back in so the environment variables are applied to newly launched applications.

## 4. Add a Chinese input engine

Open the configuration tool:

```bash
fcitx5-configtool
```

Add a Pinyin input method (for example, **Pinyin**) and keep your regular keyboard layout available for English input. The default input-method toggle is commonly `Ctrl+Space`; it can be changed in Fcitx5 settings. Exact names may differ slightly by installed addon/version.

## 5. Enable a Chinese locale (optional)

A Chinese input method does not require changing the system locale. If you also want system messages and applications to prefer Simplified Chinese:

1. Edit `/etc/locale.gen` and uncomment both:
   `en_US.UTF-8 UTF-8` and `zh_CN.UTF-8 UTF-8`.
2. Generate locales and set the default:

```bash
sudo locale-gen
sudo localectl set-locale LANG=zh_CN.UTF-8
```

Keep `en_US.UTF-8` generated as a useful fallback. Do not set `LC_ALL` globally. Some desktop applications use their own language setting or may not ship Chinese translations, so changing the locale does not guarantee every application UI will be Chinese.

## 6. Verify fonts and input

```bash
fc-cache -fv
fc-list :lang=zh family | sort -u | head -20
pgrep -a fcitx5
fcitx5-remote
echo "$LANG"
```

If Chinese characters are missing in Waybar, you can add a CJK fallback to `~/.config/waybar/style.css`:

```css
* {
  font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK SC", sans-serif;
}
```

Use the font family name reported by `fc-list` if your installed Nerd Font has a different name.

## Troubleshooting

- If the input method does not appear, confirm `fcitx5` is running and that the input engine is added in `fcitx5-configtool`.
- If it works in some apps but not others, fully restart the affected apps after logging in again; native Wayland, XWayland, GTK and Qt apps can use different input-method paths.
- Check logs with `journalctl --user -b | grep -i fcitx`.
- If an application already provides its own input-method integration, avoid stacking multiple global GTK/Qt overrides.
- See the [ArchWiki Fcitx5 guide](https://wiki.archlinux.org/title/Fcitx5), [Chinese localization guide](https://wiki.archlinux.org/title/Localization/Chinese), and [Input method guide](https://wiki.archlinux.org/title/Input_method).
