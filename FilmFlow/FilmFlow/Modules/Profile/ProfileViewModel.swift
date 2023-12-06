

import UIKit
import Combine

final class ProfileViewModel: ObservableObject, RoutableViewModel {
  
    // MARK: - Properties
    
    private var dataManager: ProfileDataManager?
    var cancellables = Set<AnyCancellable>()
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    // MARK: - Object lifecycle
    
    init() {
        registerRoutesToNavigate()
    }
    
    func set(dataManager: ProfileDataManager, parameters: [String: Any]? = nil) {
        self.dataManager = dataManager
        print(parameters)
    }
    
    func makeView(parameters: [String: Any]?) -> UIViewController {
        ProfileWireframe().getView(parameters: parameters)
    }
    
    func registerRoutesToNavigate() {
//        NavigationRouter.main.bind(routes: [
//            NavigationRoute(path: ProfileWireframe.path, viewModelType: ProfileViewModel.self, requiresAuthentication: false)
//        ])
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
