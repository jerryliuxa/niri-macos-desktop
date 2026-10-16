# Clipboard history with Walker + Elephant

This project uses Walker as the search UI and Elephant's `clipboard` provider to keep searchable clipboard history. The provider supports text and image entries; exact behavior and retention options depend on the installed Elephant version.

## 1. Install the provider

On Arch Linux, install the optional AUR provider package:

```bash
yay -S --needed elephant-clipboard
```

If you use `paru`, replace `yay` with `paru`. Keep `walker` and the Elephant service installed as described in the main README.

## 2. Ensure Elephant is running

```bash
elephant service enable
systemctl --user enable --now elephant.service
systemctl --user status elephant.service
elephant providers list
```

Confirm the clipboard provider is listed. If it is missing, check that `elephant-clipboard` is installed and restart the user service:

```bash
systemctl --user restart elephant.service
journalctl --user -u elephant.service -b
```

The service must run in your user session so it can access the Wayland clipboard environment. Do not configure it as a system-wide service.

## 3. Search clipboard history

Open Walker with `Super + Space` (the project's default example binding), then type the provider prefix `:` followed by a search term. For example:

```text
:github
:meeting
```

The `:` prefix selects the clipboard provider. Choose a result to activate it; the provider's available actions may vary by version. You can also bind a dedicated shortcut to open Walker for this workflow.

## 4. Optional dedicated shortcut

Add this line inside your existing `binds { ... }` block in `~/.config/niri/config.kdl`:

```kdl
Mod+V { spawn "walker"; }
```

This opens Walker, but does not automatically type the clipboard prefix. After it opens, type `:` and then your search term. If `Mod+V` is already assigned, choose another shortcut. Keep the existing `Mod+Space` binding if you still want the general launcher.

Validate your Niri config after editing:

```bash
niri validate
```

## 5. Privacy and retention

Clipboard history can capture anything copied, including passwords, API keys, authentication tokens, private messages, addresses, and financial data.

- Review the provider's current configuration before relying on it. Generate/read the installed version's config documentation with `elephant generatedoc clipboard` if supported, and inspect `~/.config/elephant/clipboard.toml`.
- Configure retention limits or sensitive-content exclusions only if your installed provider version explicitly supports them; do not assume they are enabled by default.
- Avoid copying secrets while clipboard history is active, and do not enable clipboard sync/history on a shared account without considering the privacy impact.
- Clear stored entries using the provider's supported UI/actions or documented CLI for your installed version.
- Treat clipboard history as local sensitive data; protect your user account and backups.

## Troubleshooting

- **No results:** check `elephant providers list`, confirm `elephant-clipboard` is installed, then restart `elephant.service`.
- **Nothing is being recorded:** confirm Elephant is running inside the graphical user session and that a Wayland clipboard tool/application is available.
- **Walker shows normal app results instead:** enter the `:` prefix first, then your search query.
- **Hotkey doesn't work:** ensure the binding is inside the existing Niri `binds { ... }` block and run `niri validate`.

## References

- [Walker providers documentation](https://walkerlauncher.com/docs/providers)
- [Elephant upstream repository](https://github.com/abenz1267/elephant)
