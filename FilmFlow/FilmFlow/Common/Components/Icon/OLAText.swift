//
//  OLAText.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import SwiftUI
import UIKit

public struct OLAText: View {
    // MARK: - Properties
    
    internal let text: String?
    
    internal let style: TextStyle
    
    internal let alignment: TextAlignment
    
    internal let underline: Bool
    
    
    // MARK: - Initializer
    
    public init(_ text: String?, style: TextStyle, alignment: TextAlignment = .leading, underline: Bool = false) {
        self.text = text
        self.style = style
        self.alignment = alignment
        self.underline = underline
    }
    
    // MARK: - View builder
    
    public var body: some View {
        Text(text?.localized ?? "")
            .underline(underline)
            .kerning(style.letterSpacing)
            .multilineTextAlignment(alignment)
            .textStyle(style)
    }
}

