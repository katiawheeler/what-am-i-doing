import AppKit
import SwiftUI

// Custom window that can become key (required for text input in borderless windows)
class KeyableWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

class DrawerWindowController: NSObject {
    private var window: NSWindow?
    private var statusItem: NSStatusItem?
    private var trackingArea: NSTrackingArea?
    private var statusMenu: NSMenu?

    private let drawerWidth: CGFloat = 340
    private let collapsedHeight: CGFloat = 42

    override init() {
        super.init()
        setupStatusItem()
        setupWindow()
        setupScreenChangeObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupScreenChangeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }

    @objc private func screenDidChange(_ notification: Notification) {
        // Reposition window when screen configuration changes (resize, display change, etc.)
        guard let window = window, window.isVisible else { return }
        positionWindow()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            if let image = NSImage(named: "MenuBarIcon") {
                image.isTemplate = true
                button.image = image
            } else {
                // Fallback to system symbol
                button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Pomodoro Timer")
            }
            button.action = #selector(toggleWindow)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // Create right-click menu
        let menu = NSMenu()
        let quitItem = NSMenuItem(title: "Quit What Am I Doing?", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        self.statusMenu = menu
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    private func setupWindow() {
        // Create the SwiftUI view
        let drawerView = DrawerView()
        let hostingView = NSHostingView(rootView: drawerView)

        // Create window (using KeyableWindow for text input support)
        window = KeyableWindow(
            contentRect: NSRect(x: 0, y: 0, width: drawerWidth, height: collapsedHeight),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        guard let window = window else { return }

        window.contentView = hostingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.isMovableByWindowBackground = false
        window.hasShadow = false // We handle shadows in SwiftUI

        positionWindow()
    }

    private func positionWindow() {
        guard let window = window else { return }

        // Try to position below the status item button
        if let button = statusItem?.button,
           let buttonWindow = button.window {
            // Get button position in screen coordinates
            let buttonRect = button.convert(button.bounds, to: nil)
            let screenRect = buttonWindow.convertToScreen(buttonRect)

            // Center the drawer below the button (tucked up slightly)
            let x = screenRect.midX - (drawerWidth / 2)
            let y = screenRect.minY - collapsedHeight + 8

            window.setFrameOrigin(NSPoint(x: x, y: y))
            return
        }

        // Fallback: use visible frame of main screen
        guard let screen = NSScreen.main else { return }
        let visibleFrame = screen.visibleFrame

        // Position at top center of visible area
        let x = visibleFrame.origin.x + (visibleFrame.width - drawerWidth) / 2
        let y = visibleFrame.origin.y + visibleFrame.height - collapsedHeight

        window.setFrameOrigin(NSPoint(x: x, y: y))
    }

    @objc private func toggleWindow(_ sender: NSStatusBarButton?) {
        guard let event = NSApp.currentEvent else { return }

        // Right-click shows menu
        if event.type == .rightMouseUp {
            if let button = statusItem?.button, let menu = statusMenu {
                menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height + 5), in: button)
            }
            return
        }

        // Left-click toggles drawer
        guard let window = window else { return }

        if window.isVisible {
            window.orderOut(nil)
        } else {
            positionWindow()
            window.makeKeyAndOrderFront(nil)
        }
    }

    func showWindow() {
        // Delay to ensure status item is fully initialized
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, let window = self.window else { return }
            self.positionWindow()
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: false)
        }
    }

    func hideWindow() {
        window?.orderOut(nil)
    }

    func updateWindowHeight(_ height: CGFloat) {
        guard let window = window else { return }

        var x: CGFloat
        var y: CGFloat

        // Try to position below the status item button
        if let button = statusItem?.button,
           let buttonWindow = button.window {
            let buttonRect = button.convert(button.bounds, to: nil)
            let screenRect = buttonWindow.convertToScreen(buttonRect)

            x = screenRect.midX - (drawerWidth / 2)
            y = screenRect.minY - height + 8
        } else if let screen = NSScreen.main {
            // Fallback: use visible frame
            let visibleFrame = screen.visibleFrame
            x = visibleFrame.origin.x + (visibleFrame.width - drawerWidth) / 2
            y = visibleFrame.origin.y + visibleFrame.height - height
        } else {
            return
        }

        var frame = window.frame
        frame.size.height = height
        frame.origin = NSPoint(x: x, y: y)

        window.setFrame(frame, display: true, animate: true)
    }
}
