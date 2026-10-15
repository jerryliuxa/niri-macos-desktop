# Dock limitations on Niri

A macOS-like dock is separate from the Walker + Elephant search launcher.

This repository includes an optional scripts/start-dock starter for nwg-dock, but does not promise a complete macOS Dock experience. Inspect the options supported by your installed build:

~~~bash
nwg-dock --help
~~~

Potential limitations include:

- Running-app indicators may depend on how the dock discovers windows and application IDs.
- Auto-hide and edge-reveal behavior can vary with layer-shell support, output layout and compositor behavior.
- Magnification/hover animation is not guaranteed by every build.
- Multi-monitor and fractional-scaling behavior may differ from macOS.
- Do not assume flags found in an online example are supported by your installed version.

If a feature does not work, keep Waybar and Walker as the reliable core UI and treat the Dock as optional.
