//
//  NavigationRouter+PathMatcher.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import Foundation

// MARK: - Path matcher
extension NavigationRouter {
    /// Gets whether given path matches given route path
    /// - Parameters:
    ///   - path: Path to be compared
    ///   - routePath: Route path
    internal func path(_ path: String, matchesRoutePath routePath: String) -> Bool {
        // Create patch matcher instance
        let pathMatcher: PathMatcher = PathMatcher(match: routePath, exact: true)
        
        // Invoke matching method
        return pathMatcher.matches(path)
    }
    
    /// Gets dictionary parameters from given path
    /// - Parameters:
    ///   - path: Path
    ///   - toDictionaryForRoutePath: Route path
    internal func path(_ path: String, toDictionaryForRoutePath routePath: String) -> [String: String]? {
        // Make sure route matches
        guard self.path(path, matchesRoutePath: routePath) else {
            return nil
        }
        
        // Instantiate matcher
        let pathMatcher: PathMatcher = PathMatcher(match: routePath, exact: true)
        
        // Parse parameters
        return try? pathMatcher.execute(path: path)
    }
}
