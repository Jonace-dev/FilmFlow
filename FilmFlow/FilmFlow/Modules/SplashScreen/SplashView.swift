
import SwiftUI
import Lottie

struct SplashView: View {
    
    @ObservedObject private var viewModel: SplashViewModel
    @State private var rootPath: String = ChangeAccountWireframe.path
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea(.all)
            VStack(alignment: .center) {
                LottieView(loopMode: .playOnce, animation: "splash", completion: { finished in
                    if finished {
                        navigateToRootView()
                    }
                })
                .scaleEffect(0.9)
            }
            .navigationBarHidden(true)
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .edgesIgnoringSafeArea(.vertical)
        }
       
    }
    
    /// Gets root view controller
    private func navigateToRootView() {
        // Navigate to home once route is available
        if isAnyActiveSceneReady() {
            NavigationRouter.main.navigate(toPath: rootPath)
        }
    }
    
    /// Whether there's an active scene ready or not
    private func isAnyActiveSceneReady() -> Bool {
        // Ensure there's an active scene ready for navigation
        guard let keyWindow = NavigationRouter.main.activeWindow,
            let _: UIViewController = keyWindow.rootViewController else {
            return false
        }
    
        return true
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashWireframe().view
    }
}
