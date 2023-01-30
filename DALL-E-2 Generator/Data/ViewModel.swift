import Foundation

class ViewModel: ObservableObject {
    @Published var prompt: String = ""
    @Published var responseURL: URL?
    @Published var displayImage: Bool = false
}
