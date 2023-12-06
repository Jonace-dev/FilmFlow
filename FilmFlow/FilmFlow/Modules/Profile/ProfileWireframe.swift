//
//  ProfileWireframe.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 4/12/23.
//
//  Copyright (c) 2023 VASS Consultoria de Sistemas. All rights reserved.


import UIKit


class ProfileWireframe {
    
    // MARK: - Properties
    
    static var path = "/profile"
    
    var parameters: [String: Any]?
    
    var view: ProfileView {
        ProfileView(viewModel: viewModel)
    }
    
    private var viewModel: ProfileViewModel {
        let profileViewModel = ProfileViewModel()
        profileViewModel.set(dataManager: dataManager, parameters: parameters)
        return profileViewModel
    }
    
    private var dataManager: ProfileDataManager {
        ProfileDataManager(apiClient: apiClient)
    }
    
    private var apiClient: ProfileAPIClient {
        ProfileAPIClient()
    }
    
    func getView(parameters: [String: Any]? = nil) -> UIViewController {
        self.parameters = parameters
        return view.asUIViewController()
    }

}
