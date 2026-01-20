import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var currentTask: String = "" {
        didSet {
            saveTask()
        }
    }

    private let taskKey = "currentTask"

    init() {
        loadTask()
    }

    var displayTask: String {
        currentTask.isEmpty ? "What are you doing?" : currentTask
    }

    var isEmpty: Bool {
        currentTask.isEmpty
    }

    private func loadTask() {
        currentTask = UserDefaults.standard.string(forKey: taskKey) ?? ""
    }

    private func saveTask() {
        UserDefaults.standard.set(currentTask, forKey: taskKey)
    }
}
