# niri-macos-desktop

macOS Sonoma / Sequoia-inspired desktop setup for **Arch Linux + Niri**. This starter kit combines a translucent Waybar menu bar, an optional Dock launcher, and **Walker + Elephant** as a Spotlight-style search launcher.

> Status: configuration starter kit. It has not been tested on your machine. Package availability and upstream CLI/config details can change; validate locally before making it part of your daily session.

## Features

- Waybar top bar with Niri workspaces, focused window, audio, network, and clock.
- Walker search UI backed by Elephant providers.
- Super + Space opens Walker after you add the binding snippet to your existing Niri binds block.
- Optional Elephant providers for desktop apps, calculator, file search, command runner, web search, and clipboard history.
- Installer backs up existing Waybar files instead of silently replacing them.
- Optional Dock starter script and documented Niri limitations.

## Repository layout

- install.sh — installs Arch packages and copies project configs with timestamped backups.
- waybar/ — Waybar JSONC and CSS.
- niri/config.kdl.example — key binding and startup examples; **not** a complete Niri configuration.
- walker/ — Walker setup and theme notes.
- elephant/ — provider and service setup notes.
- scripts/start-dock — optional nwg-dock launcher.
- docs/ — setup and compatibility notes.

## Install

### 1. Clone

~~~bash
git clone https://github.com/jerryliuxa/niri-macos-desktop.git
cd niri-macos-desktop
~~~

### 2. Install packages and copy Waybar files

The script targets Arch Linux and requires pacman plus an AUR helper such as yay or paru for Walker, Elephant and providers.

~~~bash
chmod +x install.sh scripts/start-dock
./install.sh
~~~

The installer backs up existing files it replaces under ~/.config/niri-macos-desktop-backups/. It does not replace ~/.config/niri/config.kdl.

### 3. Enable Elephant

Common AUR provider packages include:

~~~bash
yay -S --needed walker elephant elephant-providerlist elephant-desktopapplications elephant-calc elephant-files elephant-runner elephant-websearch
~~~

Optional clipboard provider (clipboard history can contain sensitive data):

~~~bash
yay -S --needed elephant-clipboard
~~~

Then enable/start the user service:

~~~bash
elephant service enable
systemctl --user enable --now elephant.service
~~~

Check provider and service health:

~~~bash
elephant providers list
systemctl --user status elephant.service
~~~

Start Walker once to generate its default config and theme directory:

~~~bash
walker
~~~

### 4. Configure Niri shortcut

Open ~/.config/niri/config.kdl and add this line **inside your existing binds { ... } block**:

~~~kdl
Mod+Space { spawn "walker"; }
~~~

Do not create a second binds block blindly and do not replace your complete Niri config with the example. If Mod+Space is already used, choose another shortcut.

Validate with:

~~~bash
niri validate
~~~

### 5. Start Waybar

The installer copies files to ~/.config/waybar/. Start/restart it with:

~~~bash
pkill waybar 2>/dev/null || true
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"
~~~

For automatic startup, add spawn-at-startup "waybar" at the top level of your Niri config if Waybar is not already started by your session/autostart setup.

## Walker usage

- Type an application name and press Enter to launch it.
- Use arrow keys to select results and Escape to close.
- Provider prefixes vary by enabled providers. Consult the current Walker docs for supported prefixes.
- Calculator, files, web search, clipboard and runner results only appear when their Elephant providers are installed and working.

## Dock note

scripts/start-dock is an optional experiment with nwg-dock. It is not required for Walker or Waybar. See docs/dock-limitations.md: a generic dock may not expose macOS-like running indicators, magnification, or reliable auto-hide under Niri.

## Safety and backups

- Review scripts before running them.
- The installer uses timestamped backups for project-owned Waybar files.
- It does not modify your Niri config; keybinding examples are manual.
- Clipboard history can retain private text. Enable it only if you understand the provider behavior.
- Appearance varies with GTK themes, icon themes, fonts, scaling and monitor layout.

## Upstream references

- Walker docs: https://walkerlauncher.com/docs/
- Walker source: https://github.com/abenz1267/walker
- Elephant source: https://github.com/abenz1267/elephant
- Niri config: https://github.com/niri-wm/niri
- Waybar: https://github.com/Alexays/Waybar
