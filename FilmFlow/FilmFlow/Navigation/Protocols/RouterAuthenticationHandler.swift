//
//  NavigationRouter.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import Foundation

/// Router authentication handler
public protocol RouterAuthenticationHandler {
    // MARK: - Authentication
    
    /// Gets whether user is authenticated or not
    func isAuthenticated() -> Bool
    
    /// Logins user
    /// - Parameter completion: Completion handler
    func login(completion: (() -> Void)?)
    
    /// Logouts user
    /// - Parameter completion: Completion handler
    func logout(completion: (() -> Void)?)
    
    /// Gets whether authentication handler can handle given callback URL or not
    /// - Parameter url: URL to be handled
    func canHandleCallbackUrl(_ url: URL) -> Bool
    
    /// Handles given callback URL
    /// - Parameter url: URL to be handled
    func handleCallbackUrl(_ url: URL)
}
