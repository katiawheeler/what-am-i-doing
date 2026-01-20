import SwiftUI

struct HeaderView: View {
    @ObservedObject var timerVM: TimerViewModel
    @ObservedObject var taskVM: TaskViewModel
    let isExpanded: Bool
    let isHovered: Bool

    private var headerHeight: CGFloat {
        isExpanded ? 42 : (isHovered ? 48 : 42)
    }

    private var timerFontSize: CGFloat {
        isHovered && !isExpanded ? 22 : 20
    }

    private var taskFontSize: CGFloat {
        isHovered && !isExpanded ? 14 : 13
    }

    var body: some View {
        HStack(spacing: 12) {
            // Timer
            Text(timerVM.formattedTime)
                .font(.custom("IBMPlexMono-SemiBold", size: timerFontSize))
                .foregroundColor(AppColors.accentColor(for: timerVM.state))
                .shadow(color: AppColors.glowColor(for: timerVM.state), radius: 15, x: 0, y: 0)
                .frame(minWidth: 70, alignment: .leading)
                .modifier(PulseModifier(isActive: timerVM.state == .paused))

            Spacer()

            // Task
            Text(taskVM.displayTask)
                .font(.custom("DMSans-Medium", size: taskFontSize))
                .foregroundColor(taskVM.isEmpty ? AppColors.textMuted : AppColors.textPrimary)
                .fontWeight(taskVM.isEmpty ? .regular : .medium)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            // Expand indicator
            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.textMuted)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
        }
        .padding(.horizontal, 16)
        .frame(height: headerHeight)
        .animation(.easeInOut(duration: 0.3), value: isHovered)
    }
}

struct PulseModifier: ViewModifier {
    let isActive: Bool
    @State private var opacity: Double = 1.0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                guard isActive else { return }
                withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                    opacity = 0.55
                }
            }
            .onChange(of: isActive) { newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                        opacity = 0.55
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        opacity = 1.0
                    }
                }
            }
    }
}
