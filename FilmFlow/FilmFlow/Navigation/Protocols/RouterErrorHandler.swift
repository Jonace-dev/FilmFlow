//
//  NavigationRouter.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

/// Error handler interface for NavigationRouter
public protocol RouterErrorHandler {
    /// Handles given error
    /// - Parameter error: Error to be handled
    func handleError(_ error: Error)
}
