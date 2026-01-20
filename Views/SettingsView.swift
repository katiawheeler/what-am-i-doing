import SwiftUI

struct SettingsView: View {
    @ObservedObject var timerVM: TimerViewModel

    var body: some View {
        HStack(spacing: 12) {
            SettingItem(
                label: "Focus",
                value: "\(timerVM.settings.focusDuration)m",
                options: PomodoroSettings.focusOptions.map { "\($0)m" },
                onSelect: { index in
                    timerVM.updateFocusDuration(PomodoroSettings.focusOptions[index])
                }
            )

            SettingItem(
                label: "Break",
                value: "\(timerVM.settings.breakDuration)m",
                options: PomodoroSettings.breakOptions.map { "\($0)m" },
                onSelect: { index in
                    timerVM.updateBreakDuration(PomodoroSettings.breakOptions[index])
                }
            )

            SettingItem(
                label: "Sound",
                value: timerVM.settings.soundEnabled ? "On" : "Off",
                options: ["On", "Off"],
                onSelect: { _ in
                    timerVM.toggleSound()
                }
            )
        }
    }
}

struct SettingItem: View {
    let label: String
    let value: String
    let options: [String]
    let onSelect: (Int) -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            Text(label.uppercased())
                .font(.custom("IBMPlexMono-Medium", size: 9))
                .tracking(1)
                .foregroundColor(AppColors.textMuted)

            Button(action: cycleOption) {
                Text(value)
                    .font(.custom("IBMPlexMono-Regular", size: 12))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(isHovered ? 0.08 : 0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(isHovered ? 0.15 : 0.1), lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .onHover { hovering in
                withAnimation(.easeOut(duration: 0.15)) {
                    isHovered = hovering
                }
            }
        }
    }

    private func cycleOption() {
        guard let currentIndex = options.firstIndex(of: value) else { return }
        let nextIndex = (currentIndex + 1) % options.count
        onSelect(nextIndex)
    }
}
