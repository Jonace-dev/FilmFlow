//
//  UserChangeAccount.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 8/12/23.
//

import Foundation

struct UserChangeAccount: Codable, Hashable {
    let username: String
    let image: String
    
    static func getDefaultUsers() -> [UserChangeAccount] {
        return [
            UserChangeAccount(username: "jonace", image: "witcher"),
            UserChangeAccount(username: "peludita", image: "default1"),
            UserChangeAccount(username: "Kids", image: "kids")
        ]
    }
}
