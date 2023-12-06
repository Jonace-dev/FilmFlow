//
//  NavigationRouter.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import UIKit
import Combine
import SwiftUI

/// Navigation router
public final class NavigationRouter {
    // MARK: - Static fields
    
    /// Main router
    public static let main: NavigationRouter = NavigationRouter()
    
    // MARK: - Fields
    
    // MARK: Public fields
    
    /// Authentication handler
    public var authenticationHandler: RouterAuthenticationHandler?
    
    /// Error handler
    public var errorHandler: RouterErrorHandler?
    
    /// External navigation delay
    public var externalNavigationDelay: TimeInterval = 1
    
    // MARK: Internal fields
    
    /// Registered routes
    internal var routes: Set<NavigationRoute> = []
    
    /// Interceptors array
    internal var interceptors: [NavigationInterceptor] = []
    
    /// Gets whether user is authenticated or not
    internal var isUserAuthenticated: Bool {
        // Defaults to true
        return authenticationHandler?.isAuthenticated() ?? true
    }
    
    /// The current path the navigation router in navigating
    internal var currentNavigationPath: String?
    
    /// Dispatch queue for background operations
    internal let dispatchQueueBackground: DispatchQueue = DispatchQueue(label: "NavigationRouter",
                                                                        qos: .userInitiated,
                                                                        attributes: .concurrent,
                                                                        autoreleaseFrequency: .inherit,
                                                                        target: .global())
    
    internal var preconditionActions: [() -> Void] = []
    
    // MARK: - Initializers
    
    /// Initialializes a new instance with given data
    private init() { }
    
    // MARK: - Public methods
    
    public var activeWindow: UIWindow? {
        var window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene}).compactMap({$0})
            .first?.windows.filter({$0.isKeyWindow}).first
        
        if window != nil {
            return window
        }
        
        window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundInactive})
            .map({$0 as? UIWindowScene}).compactMap({$0})
            .first?.windows.filter({$0.isKeyWindow}).first
        
        return window
    }
    
    public var navigationController: UINavigationController? {
        return (activeWindow?.rootViewController?.presentedViewController ?? activeWindow?.rootViewController)
            as? UINavigationController
    }
    
    // MARK: Navigation binding
    
    /// Binds given routes
    /// - Parameter routes: Routes to be registered
    public func bind(routes: [NavigationRoute]) {
        for route in routes {
            self.bind(route: route)
        }
    }
    
    /// Binds given route
    /// - Parameter route: Route to be registered
    public func bind(route: NavigationRoute) {
        // Ensure route is not already registered
        guard !self.routes.contains(route) else {
            return
        }
        
        // Register route
        _ = self.routes.insert(route)
    }
    
    /// Unbind given routes
    /// - Parameter routes: Routes to be unregistered
    public func unbind(routes: [NavigationRoute]) {
        for route in routes {
            self.unbind(route: route)
            self.removeInterceptors(forPath: route.path)
        }
    }
    
    /// Unbinds given route
    /// - Parameter route: Route to be unregistered
    public func unbind(route: NavigationRoute) {
        self.routes.remove(route)
    }
    
    // MARK: - Precondition actions
    
    public func addPreconditionAction(_ preconditionAction: @escaping () -> Void) {
        preconditionActions.append(preconditionAction)
    }
    
    public func executePreconditionActions() {
        preconditionActions.forEach { $0() }
    }
    
    public func clearPreconditionActions() {
        preconditionActions = []
    }
}

