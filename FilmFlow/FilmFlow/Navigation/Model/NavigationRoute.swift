//
//  NavigationRoute.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import Foundation
import SwiftUI

/// Navigation route
public struct NavigationRoute: Hashable {
    // MARK: - Fields
    
    /// Path
    internal var path: String // e.g. /feature1
    
    /// Whether the route requires authentication or not, defaults to true
    internal var requiresAuthentication: Bool
    
    /// View
    internal var viewModelType: RoutableViewModel.Type
    
    /// Whether the route is allowed externally or not
    internal var allowedExternally: Bool
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - path: Path for navigation route (with wildcards for parameters)
    ///   - viewModelType: Any.Type conforming to RoutableViewModel used for instantiation
    ///   - requiresAuthentication: Whether the route requires authentication or not
    ///   - allowedExternally: Whether the route is allowed ot be launched externally or not
    public init(path: String,
                viewModelType: RoutableViewModel.Type,
                requiresAuthentication: Bool = true,
                allowedExternally: Bool = false) {
        self.path = path.lowercased()
        self.viewModelType = viewModelType
        self.requiresAuthentication = requiresAuthentication
        self.allowedExternally = allowedExternally
    }
    
    // MARK: - Equatable
    
    /// Gets whether two given instances are equal or not
    /// - Parameters:
    ///   - lhs: First instance to compare
    ///   - rhs: Second instance to compare
    public static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        return lhs.path == rhs.path
    }
    
    // MARK: - Hashable
    
    /// Hashes this instance into given hasher
    /// - Parameter hasher: Hasher instance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}

