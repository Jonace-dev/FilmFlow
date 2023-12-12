//
//  UIFont+Register.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 11/12/23.
//

import Foundation
import UIKit

internal extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String = "ttf") {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
