//
//  NavigationRouter+ErrorHandling.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//
import Foundation

public enum RoutingError: Error {
    case unauthorized
    case nonRegisteredRoute
    case inactiveScene
    case missingParameters
}

// MARK: - Error handling
extension NavigationRouter {
    /// Handles given error
    /// - Parameter error: Error to be handled
    internal func handleError(forPath path: String, _ error: RoutingError, completionHandler: @escaping (Bool) -> Void ) {
    #if DEBUG
    print("Router could not navigate to \(path). Error: \(error)")
    #endif
        self.errorHandler?.handleError(error)
        completionHandler(false)
    }
}

