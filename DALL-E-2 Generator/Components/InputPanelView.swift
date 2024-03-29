import SwiftUI

struct InputPanelView: View {

    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
            // MARK: - INFO PANEL
            VStack {
                TextField("Describe the image you want to be generated", text: $viewModel.prompt, axis: .vertical)
                    .lineLimit(2...)
                    .textFieldStyle(.roundedBorder)
                Button("Post") {
                    Task {
                        do {
                            viewModel.responseURL = nil
                            viewModel.displayImage = true
                            viewModel.responseURL = await URL(string: try NetworkRequest.postRequest(prompt: viewModel.prompt))
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: 420)
    }
}

struct InputPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InputPanelView(viewModel: ViewModel())
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
