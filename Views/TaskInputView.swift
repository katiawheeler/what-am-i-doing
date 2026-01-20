import SwiftUI

struct TaskInputView: View {
    @ObservedObject var taskVM: TaskViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("WHAT ARE YOU DOING?")
                .font(.custom("IBMPlexMono-Medium", size: 9))
                .tracking(2)
                .foregroundColor(AppColors.textMuted)

            TextField("Enter your current task...", text: $taskVM.currentTask)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.custom("DMSans-Regular", size: 14))
                .foregroundColor(AppColors.textPrimary)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}
