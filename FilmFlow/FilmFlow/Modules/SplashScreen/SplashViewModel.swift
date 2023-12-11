
import UIKit
import Combine

final class SplashViewModel: ObservableObject, RoutableViewModel {
    
    // MARK: - Properties
    
    private var dataManager: SplashDataManager?
    var cancellables = Set<AnyCancellable>()
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    //@Published var comics: [String] = []
    
    // MARK: - Object lifecycle
    
    init() {
        registerRoutesToNavigate()
    }
    
    func set(dataManager: SplashDataManager, parameters: [String: Any]) {
        self.dataManager = dataManager
        print(parameters)
    }
    
    func makeView(parameters: [String: Any]) -> UIViewController {
        SplashWireframe().getView(parameters: parameters)
    }
    
    func registerRoutesToNavigate() {
        NavigationRouter.main.bind(routes: [
            NavigationRoute(path: ChangeAccountWireframe.path, viewModelType: ChangeAccountViewModel.self, requiresAuthentication: false)
        ])
    }
    
    /* Call example with combine */
    
//    func getTrendingMovies() {
//        homeDataManager.getTrendingMovies()
//            .sink( receiveCompletion: { [weak self] completion in
//                if case let .failure(error) = completion {
//                    self?.errorType = .popup(error)
//                }
//            }, receiveValue: { [weak self] comics in
//                guard let self = self else { return }
//                self.comics = comics.response
//            }).store(in: &cancellables)
//    }
    
}
