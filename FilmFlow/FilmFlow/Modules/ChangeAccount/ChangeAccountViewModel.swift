
import UIKit
import Combine

final class ChangeAccountViewModel: ObservableObject, RoutableViewModel {
    
    // MARK: - Properties
    
    private var dataManager: ChangeAccountDataManager?
    var cancellables = Set<AnyCancellable>()
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    //@Published var comics: [String] = []
    
    // MARK: - Object lifecycle
    
    init() {
        registerRoutesToNavigate()
    }
    
    func set(dataManager: ChangeAccountDataManager, parameters: [String: Any]) {
        self.dataManager = dataManager
        print(parameters)
    }
    
    func makeView(parameters: [String: Any]) -> UIViewController {
        ChangeAccountWireframe().getView(parameters: parameters)
    }
    
    func registerRoutesToNavigate() {
        NavigationRouter.main.bind(routes: [
            NavigationRoute(path: HomeWireframe.path, viewModelType: HomeViewModel.self, requiresAuthentication: false)
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
