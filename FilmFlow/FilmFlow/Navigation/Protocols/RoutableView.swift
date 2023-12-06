//
//  NavigationRouter.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import SwiftUI

/// Routable view
public protocol RoutableView: SwiftUI.View {
    // MARK: - Associated types
    
    // MARK: - View model type
    associatedtype ViewModel: RoutableViewModel
    
    // MARK: - Fields
    
    /// View model instance
    var viewModel: Self.ViewModel { get }
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given view model
    /// - Parameter viewModel: View model instance
    init(viewModel: Self.ViewModel)
}
