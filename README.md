# What Am I Doing?

A minimal macOS menu bar pomodoro timer with a sleek drawer UI that peeks out from under the menu bar.

## Features

- **Drawer UI** - Slides down from the menu bar, always showing your current task and time remaining
- **Hover to preview** - Drawer grows slightly on hover for a quick glance
- **Click to expand** - Full controls, task input, and settings
- **Focus & Break cycles** - Configurable durations (5-45 min focus, 3-15 min break)
- **Visual states** - Coral glow when focusing, teal during breaks, amber pulse when paused
- **System notifications** - Get notified when timers complete
- **Keyboard support** - Press Escape to collapse the drawer
- **Lightweight** - Native Swift/SwiftUI, no Electron bloat

## Usage

1. Click the timer icon in your menu bar to toggle the drawer
2. Click the drawer to expand and access controls
3. Enter what you're working on in the task field
4. Hit play to start your focus session
5. Right-click the menu bar icon to quit

## Building

Requires Xcode 15+ and macOS 13+.

```bash
xcodegen generate
open WhatAmIDoing.xcodeproj
```

Then build and run with `Cmd+R` in Xcode.

## Tech Stack

- Swift 5.9
- SwiftUI
- AppKit (NSStatusItem, NSWindow)
- XcodeGen for project generation

## Design

- **Typography**: IBM Plex Mono (timer), DM Sans (task)
- **Colors**: Dark charcoal background with warm accent colors
  - Focus: `#e87b5f` (coral)
  - Break: `#5eb89e` (teal)
  - Paused: `#d4a94d` (amber)

## License

MIT
