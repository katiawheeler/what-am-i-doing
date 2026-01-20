import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AppColors {
    static let drawerBg = Color(hex: "1c1c21")
    static let drawerSurface = Color(hex: "252529")

    static let accentFocus = Color(hex: "e87b5f")
    static let accentFocusGlow = Color(hex: "e87b5f").opacity(0.25)

    static let accentBreak = Color(hex: "5eb89e")
    static let accentBreakGlow = Color(hex: "5eb89e").opacity(0.25)

    static let accentPaused = Color(hex: "d4a94d")
    static let accentPausedGlow = Color(hex: "d4a94d").opacity(0.25)

    static let textPrimary = Color(hex: "f5f5f7")
    static let textMuted = Color(hex: "7c7c86")

    static let borderSubtle = Color.white.opacity(0.06)

    static func accentColor(for state: TimerState) -> Color {
        switch state {
        case .focus:
            return accentFocus
        case .break_:
            return accentBreak
        case .paused:
            return accentPaused
        case .idle:
            return accentFocus
        }
    }

    static func glowColor(for state: TimerState) -> Color {
        switch state {
        case .focus:
            return accentFocusGlow
        case .break_:
            return accentBreakGlow
        case .paused:
            return accentPausedGlow
        case .idle:
            return accentFocusGlow
        }
    }
}
