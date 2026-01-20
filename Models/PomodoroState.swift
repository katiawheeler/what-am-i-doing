import Foundation

enum TimerState: String, Codable {
    case idle
    case focus
    case break_
    case paused

    var label: String {
        switch self {
        case .idle: return "Ready"
        case .focus: return "Focus Time"
        case .break_: return "Break Time"
        case .paused: return "Paused"
        }
    }
}

struct PomodoroSettings: Codable {
    var focusDuration: Int = 25 // minutes
    var breakDuration: Int = 5  // minutes
    var soundEnabled: Bool = true

    static let focusOptions = [5, 10, 15, 20, 25, 30, 45]
    static let breakOptions = [3, 5, 10, 15]
}
