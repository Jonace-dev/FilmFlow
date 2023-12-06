//
//  OLATextStyle.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import SwiftUI

// MARK: - TextStyle

public enum TextStyle {
    
    // MARK: OLA Styles - Order by types
    
    // Title styles
    case title
    
    // Text styles
    
    case regular


    // Button styles
   
    
    // Button styles
   
    
    // Custom style (only to be used if no other style mathes the UI requirement)
    case custom(font: Font, color: Color = .primaryBrand, textCase: Text.Case? = nil)
    
    // MARK: - Helpers
    
    internal var modifier: TextStyleViewModifier {
        
        // MARK: Text Styles
        
        switch self {
        case .title:
            return .init(font: .bold(size: 26), color: .secondaryWhite)
        case .regular:
            return .init(font: .regular(size: 18), color: .secondaryWhite)
        case .custom(font: let font, color: let color, textCase: let textCase):
            return .init(font: font, color: color, textCase: textCase)
        }
    }
    
    
    public var letterSpacing: CGFloat {
        switch self {
        case .title:
            return 0.8
        default:
            return 0
        }
    }
}

// MARK: - TextStyle View Modifier

internal struct TextStyleViewModifier: ViewModifier {
    // MARK: Constants
    
    /// Text style font
    internal let font: Font
    
    /// Text style color
    internal let color: Color
    
    /// Line spacing
    internal let lineSpacing: CGFloat
    
    internal let textCase: Text.Case?
    
    // MARK: - Initializer
    
    internal init(font: Font, color: Color, lineSpacing: CGFloat = 4, textCase: Text.Case? = nil) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
        self.textCase = textCase
    }
    
    // MARK: Body builder
    
    /// Body function of view modifier
    /// - Parameter content: content view
    internal func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
            .textCase(textCase)
    }
}

// MARK: - View Extension

extension View {
    /// Sets the default text style for text in this view.
    public func textStyle(_ textStyle: TextStyle) -> some View {
        return self.modifier(textStyle.modifier)
    }
}

