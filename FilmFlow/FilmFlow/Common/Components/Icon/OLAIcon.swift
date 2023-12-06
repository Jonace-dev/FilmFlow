//
//  OLAIcon.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 6/12/23.
//

import SwiftUI

public enum OLAIconSize: CGFloat {
    case small = 20
    case medium = 40
    case large = 56
}

public struct OLAIcon: View {
    
    // MARK: - Properties
    
    private let iconName: String?
    
    private let size: OLAIconSize
    
    private let padding: CGFloat
    
    private let color: Color
    
    // MARK: - Initializers
    
    public init(_ iconName: String?, size: OLAIconSize, padding: CGFloat = 0, color: Color) {
        self.iconName = iconName
        self.size = size
        self.padding = padding
        self.color = color
    }
    
    public init(_ icon: IconName?, size: OLAIconSize, padding: CGFloat = 0, color: Color) {
        self.init(icon?.rawValue, size: size, padding: padding, color: color)
    }
    
    // MARK: - View builder
    
    public var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .renderingMode(.template)
            .padding(.all, padding)
            .frame(width: size.rawValue, height: size.rawValue)
            .foregroundColor(color)
    }
    
    // MARK: - Helpers
    
    private var uiImage: UIImage {
        let uiImage = UIImage(named: iconName ?? "", in: Bundle.main, with: nil)
        let size = CGSize(width: 500, height: 500)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            uiImage?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

