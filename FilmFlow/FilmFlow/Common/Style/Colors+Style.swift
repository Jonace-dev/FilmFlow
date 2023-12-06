//
//  Colors+Style.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import SwiftUI

internal enum Colors: String {
    case primaryBrand
    case secondaryWhite
    case backgroundDark
}

extension Color {
    
    public static var primaryBrand: Color {
        Color(Colors.primaryBrand.rawValue, bundle: Bundle.main)
    }
    
    public static var secondaryWhite: Color {
        Color(Colors.secondaryWhite.rawValue, bundle: Bundle.main)
    }
    
    public static var backgroundDark: Color {
        Color(Colors.backgroundDark.rawValue, bundle: Bundle.main)
    }
}


