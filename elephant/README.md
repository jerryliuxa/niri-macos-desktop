# Elephant backend

Elephant is the backend that Walker queries. Install the core package and the providers you need. Package names are AUR package names and may change over time.

## Suggested provider set

~~~bash
yay -S --needed elephant elephant-providerlist elephant-desktopapplications elephant-calc elephant-files elephant-runner elephant-websearch
~~~

## Optional clipboard provider

~~~bash
yay -S --needed elephant-clipboard
~~~

See [../docs/clipboard-history.md](../docs/clipboard-history.md) for setup, Walker search syntax, an optional Niri shortcut, troubleshooting, and privacy guidance.

Clipboard history can retain passwords, private messages, tokens or other sensitive text. Review the installed provider's configuration and retention behavior before enabling it. Do not assume sensitive-content exclusions are enabled by default.

## Enable the user service

~~~bash
elephant service enable
systemctl --user enable --now elephant.service
systemctl --user status elephant.service
elephant providers list
~~~

If the service command differs in your installed version, consult the installed help and upstream docs. Walker installation guide: https://walkerlauncher.com/docs/installation

## Common provider use cases

- Desktop applications: search and launch installed apps.
- Calculator: arithmetic expressions.
- Files: browse/search filesystem content; indexing/search scope depends on provider configuration.
- Runner: execute commands; do not execute commands you do not understand.
- Web search: query a configured search engine.
- Clipboard: recall copied text and image content, with privacy implications.
