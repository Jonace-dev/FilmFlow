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
            return "SeatBcn-Web-Medium"
        case .medium:
            return "SeatBcn-Web-Regular"
        case .bold:
            return "SeatBcn-Web-Bold"
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
    
    internal static func olaNavigationLargeTitle() -> UIFont {
        UIFont(name: Fonts.bold.fontName, size: 24)!
    }
    
}

