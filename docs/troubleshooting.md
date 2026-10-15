# Troubleshooting

## Walker opens but returns no results

1. Check the backend: systemctl --user status elephant.service.
2. Check installed providers: elephant providers list.
3. Install the desktop-applications provider if application results are missing.
4. Run walker --debug and inspect errors.

## Elephant service cannot start

Run elephant --help and elephant service --help for your installed version. Verify the user service exists with:

~~~bash
systemctl --user cat elephant.service
journalctl --user -u elephant.service -b
~~~

## Niri shortcut does not work

- Make sure the binding is inside the existing binds { ... } section.
- Check whether another binding already uses Mod+Space.
- Validate config with niri validate.
- Ensure walker is in PATH.

## Waybar fails to start

~~~bash
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"
~~~

Read terminal output for invalid modules or unsupported keys. Waybar module names and fields depend on the installed build; adapt the sample if needed.

## Icons look wrong

Install a Nerd Font and an icon theme, then configure the font in your GTK/Waybar settings. The apple glyph is font-dependent; replace it with a text glyph or icon if your font does not contain it.
