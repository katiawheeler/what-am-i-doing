import Foundation
import Combine
import UserNotifications
import AppKit

enum SessionType {
    case focus
    case breakTime
}

class TimerViewModel: ObservableObject {
    @Published var state: TimerState = .idle
    @Published var remainingSeconds: Int = 0
    @Published var settings = PomodoroSettings()

    // Track which session type we're in (focus or break)
    private(set) var currentSession: SessionType = .focus

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadSettings()
        resetToFocus()
    }

    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var isRunning: Bool {
        state == .focus || state == .break_
    }

    // MARK: - Controls

    func start() {
        if state == .idle || state == .paused {
            // Resume the correct session type
            state = currentSession == .focus ? .focus : .break_
            startTimer()
        }
    }

    func pause() {
        if isRunning {
            state = .paused
            stopTimer()
        }
    }

    func togglePlayPause() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func reset() {
        stopTimer()
        state = .idle
        currentSession = .focus
        resetToFocus()
    }

    func skip() {
        stopTimer()
        // Skip to the opposite session type
        if currentSession == .focus {
            switchToBreak()
        } else {
            switchToFocus()
        }
        // Auto-start the new session
        startTimer()
    }

    // MARK: - Timer Management

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard remainingSeconds > 0 else {
            handleTimerComplete()
            return
        }
        remainingSeconds -= 1
    }

    private func handleTimerComplete() {
        stopTimer()

        if settings.soundEnabled {
            playNotificationSound()
        }

        sendNotification()

        if state == .focus {
            switchToBreak()
            startTimer()
        } else if state == .break_ {
            switchToFocus()
            startTimer()
        }
    }

    // MARK: - State Transitions

    private func resetToFocus() {
        remainingSeconds = settings.focusDuration * 60
    }

    private func switchToFocus() {
        currentSession = .focus
        state = .focus
        remainingSeconds = settings.focusDuration * 60
    }

    private func switchToBreak() {
        currentSession = .breakTime
        state = .break_
        remainingSeconds = settings.breakDuration * 60
    }

    // MARK: - Notifications

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = state == .focus ? "Focus Complete!" : "Break Over!"
        content.body = state == .focus ? "Time for a break." : "Ready to focus again?"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func playNotificationSound() {
        NSSound(named: "Glass")?.play()
    }

    // MARK: - Settings

    func updateFocusDuration(_ minutes: Int) {
        settings.focusDuration = minutes
        if state == .idle {
            resetToFocus()
        }
        saveSettings()
    }

    func updateBreakDuration(_ minutes: Int) {
        settings.breakDuration = minutes
        saveSettings()
    }

    func toggleSound() {
        settings.soundEnabled.toggle()
        saveSettings()
    }

    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "pomodoroSettings"),
           let decoded = try? JSONDecoder().decode(PomodoroSettings.self, from: data) {
            // Validate loaded settings - reset to defaults if invalid
            if PomodoroSettings.focusOptions.contains(decoded.focusDuration) &&
               PomodoroSettings.breakOptions.contains(decoded.breakDuration) {
                settings = decoded
            } else {
                // Invalid settings found, reset to defaults
                UserDefaults.standard.removeObject(forKey: "pomodoroSettings")
            }
        }
    }

    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "pomodoroSettings")
        }
    }
}
