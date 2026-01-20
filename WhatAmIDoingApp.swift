import SwiftUI
import UserNotifications

@main
struct WhatAmIDoingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var drawerController: DrawerWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request notification permissions
        requestNotificationPermissions()

        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)

        // Initialize drawer
        drawerController = DrawerWindowController()
        drawerController?.showWindow()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}
