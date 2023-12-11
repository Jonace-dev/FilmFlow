//
//  HomeViewModel.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 29/11/23.
//

import UIKit
import Combine

final class HomeViewModel: ObservableObject, RoutableViewModel {
   
    @Published internal var movieResponse: [TrendingMovie]?
    @Published var errorType: ErrorType?
    @Published var user: UserChangeAccount?
    
    var homeDataManager: HomeDataManager?
    var cancellables = Set<AnyCancellable>()
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    init() {
        registerRoutesToNavigate()
    }
    
    func set(dataManager: HomeDataManager, parameters: [String: Any]) {
        self.homeDataManager = dataManager
        self.user = parameters["user"] as? UserChangeAccount
        print(parameters)
    }
    
    func makeView(parameters: [String: Any]) -> UIViewController {
        HomeWireframe().getView(parameters: parameters)
    }
    
    func registerRoutesToNavigate() {
        NavigationRouter.main.bind(routes: [
            NavigationRoute(path: ProfileWireframe.path, viewModelType: ProfileViewModel.self, requiresAuthentication: false)
        ])
    }
    
    
 
    func getTrendingMovies() {
        homeDataManager?.getTrendingMovies()
            .sink( receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorType = .popup(error)
                }
            }, receiveValue: { [weak self] moviesResponse in
                guard let self = self else { return }
                self.movieResponse = moviesResponse.results
            }).store(in: &cancellables)
    }
    
}
