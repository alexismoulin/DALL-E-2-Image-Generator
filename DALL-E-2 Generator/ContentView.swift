import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @StateObject var viewModel = ViewModel()
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    // MARK: - FUNCTIONS
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    // MARK: - CONTENT
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                // MARK: - PAGE IMAGE
                if viewModel.displayImage {
                    AsyncImage(url: viewModel.responseURL) { phase in
                        switch phase {
                            
                        case .empty:
                            ProgressView()
                            
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .padding()
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(.linear(duration: 1), value: isAnimating)
                                .offset(x: imageOffset.width, y: imageOffset.height)
                                .scaleEffect(imageScale)
                            // MARK: - 1. TAP GESTURE
                                .onTapGesture(count: 2, perform: {
                                    if imageScale == 1 {
                                        withAnimation(.spring()) {
                                            imageScale = 5
                                        }
                                    } else {
                                        resetImageState()
                                    }
                                })
                            // MARK: - 2. DRAG GESTURE
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            withAnimation(.linear(duration: 1)) {
                                                imageOffset = value.translation
                                            }
                                        }
                                        .onEnded { _ in
                                            if imageScale <= 1 {
                                                resetImageState()
                                            }
                                        }
                                )
                            // MARK: - 3. MAGNIFICATION
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            withAnimation(.linear(duration: 1)) {
                                                if imageScale >= 1 && imageScale <= 5 {
                                                    imageScale = value
                                                } else if imageScale > 5 {
                                                    imageScale = 5
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            if imageScale > 5 {
                                                imageScale = 5
                                            } else if imageScale <= 1 {
                                                resetImageState()
                                            }
                                        }
                                )
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            } // ZStack
            .onAppear {
              isAnimating = true
            }
            // MARK: - INPUT PANEL
            .overlay(
                InputPanelView(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.top, 30)
              , alignment: .top
            )
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
