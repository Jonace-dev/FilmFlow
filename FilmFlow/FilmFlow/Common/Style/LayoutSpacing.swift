//
//  LayoutSpacing.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import Foundation

/* ----------------------------------  WARNING  ----------------------------------
 We shouldn't add more spacings unless they are specified by the design guidelines
---------------------------------------------------------------------------------- */

public enum LayoutSpacing {
    
    public static let none: CGFloat = 0
    
    public static let ultraSmall: CGFloat = 2
    public static let extraSmall: CGFloat = 4
    public static let small: CGFloat = 8
    
    public static let smallMedium: CGFloat = 12
    public static let medium: CGFloat = 16
    public static let largeMedium: CGFloat = 20
    
    public static let large: CGFloat = 24
    public static let extraLarge: CGFloat = 32
    public static let ultraLarge: CGFloat = 40
    public static let max: CGFloat = 50
    
    public static var verticalTextFieldSpacing: CGFloat {
       return LayoutSpacing.extraSmall
    }
}

