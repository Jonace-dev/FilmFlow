//
//  Enviroment.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import Foundation

final class Environment {
    
    private let typeFileEnvironment = "plist"
    private let nameFileEnvironment = "Config"
    private let nameFeaturesNameEnvironment = "Features"
    
    
    private let keyEnvironmentURL = "baseURL"
    private let keyEnvironmentToken = "token"
    private let keyEnvironmentApiKey = "apiKey"
    
    // MARK: - Shared Instance

    static let shared = Environment()
    
    // MARK: - Init
    
    private init() {
        
        if let path = Bundle.main.path(forResource: nameFileEnvironment, ofType: typeFileEnvironment) {
            plistEnvironment = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        }
        
        if let path = Bundle.main.path(forResource: nameFeaturesNameEnvironment, ofType: typeFileEnvironment) {
            featureEnvironment = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        }
    }
    
    // MARK: - Properties

    private var plistEnvironment: [String: Any]?
    private var featureEnvironment: [String: Any]?

    var baseURL: String {
        guard let baseUrl = plistEnvironment?[keyEnvironmentURL] as? String else { fatalError("Invalid baseURL at plist") }
        return baseUrl
    }
    
    var token: String {
        guard let tokenValue = plistEnvironment?[keyEnvironmentToken] as? String else {
            fatalError("Invalid token at plist") }
        return tokenValue
    }
    
    var apiKey: String  {
        guard let apiValue = plistEnvironment?[keyEnvironmentURL] as? String else {
            fatalError("Invalid apiKey at plist") }
        return apiValue
    }
    
}

