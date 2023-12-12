//
//  Fonts.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import SwiftUI

// MARK: - OLAFont

internal enum Fonts: CaseIterable {
   
    // MARK: Fonts
    
    case regular
    case medium
    case bold
    
    // MARK: Helpers
    
    internal var fontName: String {
        switch self {
        case .regular:
            return "Roboto-Regular"
        case .medium:
            return "Roboto-Medium"
        case .bold:
            return "Roboto-Bold"
        }
    }
}

// MARK: - Font Extension

public extension Font {
    
    /// - Parameter size: Size to return font for
    static func medium(size: CGFloat) -> Font {
        return custom(Fonts.medium.fontName, size: size)
    }
    
    /// - Parameter size: Size to return font for
    static func regular(size: CGFloat) -> Font {
        return custom(Fonts.regular.fontName, size: size)
    }
    
    /// - Parameter size: Size to return font for
    static func bold(size: CGFloat) -> Font {
        return custom(Fonts.bold.fontName, size: size)
    }
}

extension UIFont {
    
    // MARK: - OLAFont - Custom funcs to return fonts
    
    internal static func olaNavigationTitle() -> UIFont {
        UIFont(name: Fonts.bold.fontName, size: 20)!
    }
    
    internal static func olaNavigationLargeTitle() -> UIFont {
        UIFont(name: Fonts.bold.fontName, size: 24)!
    }
    
    internal static func regular(size: CGFloat) -> UIFont {
        UIFont(name: Fonts.regular.fontName, size: size)!
    }
    
}

