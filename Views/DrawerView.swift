import SwiftUI

struct DrawerView: View {
    @StateObject private var timerVM = TimerViewModel()
    @StateObject private var taskVM = TaskViewModel()
    @State private var isExpanded = false
    @State private var isHovered = false

    private let collapsedHeight: CGFloat = 32
    private let hoverHeight: CGFloat = 48
    private let expandedHeight: CGFloat = 220
    private let drawerWidth: CGFloat = 340

    private var currentHeight: CGFloat {
        if isExpanded {
            return expandedHeight
        } else if isHovered {
            return hoverHeight
        }
        return collapsedHeight
    }

    var body: some View {
        VStack(spacing: 0) {
            // Always visible header
            HeaderView(
                timerVM: timerVM,
                taskVM: taskVM,
                isExpanded: isExpanded,
                isHovered: isHovered
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    isExpanded.toggle()
                }
            }

            // Expanded content
            if isExpanded {
                expandedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(width: drawerWidth, height: currentHeight)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.drawerBg)
                .overlay(
                    // Inner glow
                    RadialGradient(
                        colors: [
                            AppColors.glowColor(for: timerVM.state).opacity(0.03),
                            Color.clear
                        ],
                        center: .top,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 14,
                bottomTrailingRadius: 14,
                topTrailingRadius: 0
            )
        )
        .shadow(
            color: Color.black.opacity(0.4),
            radius: 15,
            x: 0,
            y: 6
        )
        .shadow(
            color: AppColors.glowColor(for: timerVM.state),
            radius: 25,
            x: 0,
            y: 0
        )
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: currentHeight)
        .onExitCommand {
            // Escape key pressed - collapse drawer
            if isExpanded {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    isExpanded = false
                }
            }
        }
    }

    private var expandedContent: some View {
        VStack(spacing: 16) {
            // Divider
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.08),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, 20)

            // Controls
            ControlsView(timerVM: timerVM)

            // Task input
            TaskInputView(taskVM: taskVM)
                .padding(.horizontal, 20)

            // Settings
            SettingsView(timerVM: timerVM)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
}

// Custom shape for top-flat, bottom-rounded corners
struct UnevenRoundedRectangle: Shape {
    var topLeadingRadius: CGFloat
    var bottomLeadingRadius: CGFloat
    var bottomTrailingRadius: CGFloat
    var topTrailingRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        path.move(to: CGPoint(x: topLeft.x + topLeadingRadius, y: topLeft.y))
        path.addLine(to: CGPoint(x: topRight.x - topTrailingRadius, y: topRight.y))
        path.addArc(
            center: CGPoint(x: topRight.x - topTrailingRadius, y: topRight.y + topTrailingRadius),
            radius: topTrailingRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomTrailingRadius))
        path.addArc(
            center: CGPoint(x: bottomRight.x - bottomTrailingRadius, y: bottomRight.y - bottomTrailingRadius),
            radius: bottomTrailingRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeadingRadius, y: bottomLeft.y))
        path.addArc(
            center: CGPoint(x: bottomLeft.x + bottomLeadingRadius, y: bottomLeft.y - bottomLeadingRadius),
            radius: bottomLeadingRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeadingRadius))
        path.addArc(
            center: CGPoint(x: topLeft.x + topLeadingRadius, y: topLeft.y + topLeadingRadius),
            radius: topLeadingRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        return path
    }
}

#Preview {
    DrawerView()
        .frame(width: 400, height: 300)
        .background(Color.black)
}
