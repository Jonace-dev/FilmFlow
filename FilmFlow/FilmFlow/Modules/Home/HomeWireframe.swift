//
//  HomeWireframe.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 30/11/23.
//

import UIKit

class HomeWireframe {
    
    static var path = "/home"
    var parameters: [String: Any] = [:]

    var homeView: HomeView {
        HomeView(viewModel: homeViewModel)
    }
    
    private var homeViewModel: HomeViewModel {
        let homeViewModel = HomeViewModel()
        homeViewModel.set(dataManager: homeDataManager, parameters: parameters)
        return homeViewModel
    }
                      
    private var homeDataManager: HomeDataManager {
        HomeDataManager(homeApiClient: homeApiClient)
    }
                        
    private var homeApiClient: HomeApiClient {
        HomeApiClient()
    }
    
    func getView(parameters: [String: Any]) -> UIViewController {
        self.parameters = parameters
        return homeView.asUIViewController()
    }
}
