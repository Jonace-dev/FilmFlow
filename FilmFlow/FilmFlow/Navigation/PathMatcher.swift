//
//  PathMatcher.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//


import Foundation

/**
 * This object will check whether a path matches another path (with optional variables).
 */
internal struct PathMatcher {
    // MARK: - Fields
    
    /// Path to be matched
    private let matchPath: String
    
    /// Path pattern
    private let pathPattern: String
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - matchPath: Path to be matched
    ///   - exact: Whether the matching must be exact or not
    init(match matchPath: String, exact: Bool) {
        // Prepare the pattern for a quick match.
        var newPattern = matchPath.replacingOccurrences(of: #"(:[^/?]+)"#,
                                                        with: #"([^/]+)"#,
                                                        options: .regularExpression)
        newPattern = newPattern.isEmpty ? #"\.?"# : newPattern
        
        if exact {
            newPattern = "^" + newPattern + "$"
        }
        
        self.matchPath = matchPath
        self.pathPattern = newPattern
    }
    
    /// Gets whether the path matches
    /// - Parameter path: Path to be matched
    func matches(_ path: String) -> Bool {
        path.range(of: pathPattern, options: .regularExpression) != nil
    }
    
    /// Returns a dictionary of parameter names and variables if a match was found.
    /// Will return `nil` otherwise.
    func execute(path: String) throws -> [String: String]? {
        guard matches(path) else {
            return nil
        }
        
        // Create and perform regex to catch parameter names.
        let regex = try NSRegularExpression(pattern: pathPattern, options: [])
        var parameterIndex: [Int: String] = [:]
        
        // Read the variable names from `matchPath`.
        var nsrange = NSRange(matchPath.startIndex..<matchPath.endIndex, in: matchPath)
        let variableRegex = try NSRegularExpression(pattern: #":([^\/\?]+)"#, options: [])
        var matches = variableRegex.matches(in: matchPath, options: [], range: nsrange)
        
        for (index, match) in matches.enumerated() where match.numberOfRanges > 1 {
            if let range = Range(match.range(at: 1), in: matchPath) {
                parameterIndex[index] = String(matchPath[range])
            }
        }
        
        //
        // Now get the variables from the given `path`.
        nsrange = NSRange(path.startIndex..<path.endIndex, in: path)
        matches = regex.matches(in: path, options: [], range: nsrange)
        
        var parameters: [String: String] = [:]
        
        // swiftlint:disable identifier_name
        
        for match in matches where match.numberOfRanges > 1 {
            for a in 1..<match.numberOfRanges {
                if let range = Range(match.range(at: a), in: path) {
                    if let variableName = parameterIndex[a - 1] {
                        parameters[variableName] = String(path[range])
                    }
                }
            }
        }
        
        // swiftlint:enable identifier_name
        
        return parameters
    }
}

