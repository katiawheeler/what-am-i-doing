# What Am I Doing? - Release Notes

## Version 1.0 (Initial Release)

**Release Date:** January 2026

### Overview

What Am I Doing? is a minimal macOS menu bar pomodoro timer with a sleek drawer UI that peeks out from under the menu bar. Built with native Swift and SwiftUI for a lightweight, fast experience.

### Features

#### Drawer Interface
- Slides down from the menu bar showing current task and time remaining
- Hover to preview: drawer grows slightly for a quick glance
- Click to expand: full controls, task input, and settings
- Press Escape to collapse

#### Timer Functionality
- Focus and break cycle support
- Configurable focus duration (5-45 minutes)
- Configurable break duration (3-15 minutes)
- Play, pause, skip, and reset controls

#### Visual Design
- Dark charcoal background with warm accent colors
- Coral glow (#e87b5f) when focusing
- Teal (#5eb89e) during breaks
- Amber pulse (#d4a94d) when paused
- Typography: IBM Plex Mono (timer), DM Sans (task)

#### System Integration
- Lives in menu bar - always accessible
- System notifications when timers complete
- Right-click menu bar icon to quit
- Native macOS app - no Electron

### System Requirements

- macOS 13.0 or later
- Apple Silicon or Intel Mac

### Installation

1. Open the DMG file
2. Drag "What Am I Doing?" to Applications
3. Launch from Applications or Spotlight

### Known Issues

- None reported

---

*Built with Swift 5.9, SwiftUI, and AppKit*
