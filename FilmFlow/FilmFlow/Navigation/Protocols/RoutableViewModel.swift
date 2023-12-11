//
//  NavigationRouter.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import SwiftUI

/// Routable view model
public protocol RoutableViewModel {
    // MARK: - Fields
    
    /// Navigation interception flow (if any)
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow? { get set }
    
    // MARK: - Initializers
    
    /// Instantiates a view model with given parameters
    init()
    
    
    // MARK: - View builder
    
    /// Makes view from view model
    func makeView(parameters: [String: Any]) -> UIViewController
}

extension RoutableViewModel {
    public static var requiredParameters: [String]? {
        nil
    }
}
