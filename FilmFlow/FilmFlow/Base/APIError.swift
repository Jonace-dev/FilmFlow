//
//  ApiError.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 1/12/23.
//

import Foundation

final class ApiError: Codable, Error {

    let localizedMessage: String?
    let errorCode: String?

    init(errorCode: String?, localizedMessage: String?) {
        self.errorCode = errorCode
        self.localizedMessage = localizedMessage
    }
}
