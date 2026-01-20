import SwiftUI

struct ControlsView: View {
    @ObservedObject var timerVM: TimerViewModel

    var body: some View {
        HStack(spacing: 10) {
            // Reset button
            ControlButton(
                iconName: "arrow.counterclockwise",
                action: { timerVM.reset() }
            )

            // Play/Pause button (primary)
            ControlButton(
                iconName: timerVM.isRunning ? "pause.fill" : "play.fill",
                isPrimary: true,
                accentColor: AppColors.accentColor(for: timerVM.state),
                action: { timerVM.togglePlayPause() }
            )

            // Skip button
            ControlButton(
                iconName: "forward.fill",
                action: { timerVM.skip() }
            )
        }
    }
}

struct ControlButton: View {
    let iconName: String
    var isPrimary: Bool = false
    var accentColor: Color = AppColors.accentFocus
    let action: () -> Void

    @State private var isHovered = false
    @State private var isPressed = false

    private var size: CGFloat {
        isPrimary ? 44 : 36
    }

    private var iconSize: CGFloat {
        isPrimary ? 18 : 15
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundColor(isPrimary ? AppColors.drawerBg : AppColors.textPrimary)
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isPrimary ? accentColor : Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isPrimary ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(
                    color: isPrimary ? accentColor.opacity(0.3) : Color.clear,
                    radius: isHovered ? 12 : 8,
                    x: 0,
                    y: isHovered ? 3 : 2
                )
                .scaleEffect(isPressed ? 0.96 : (isHovered ? 1.08 : 1.0))
                .offset(y: isHovered ? -1 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
