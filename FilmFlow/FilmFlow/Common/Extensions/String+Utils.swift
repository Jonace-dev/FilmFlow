//
//  String+Utils.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
