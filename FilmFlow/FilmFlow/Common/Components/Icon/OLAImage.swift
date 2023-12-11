//
//  OLAImage.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 8/12/23.
//

import SwiftUI

public enum OLAIconImage: CGFloat {
    case small = 20
    case medium = 50
    case largeSmall = 80
    case largeMedium = 100
    case large = 120
}

public struct OLAImage: View {
    
    // MARK: - Properties
    
    private let iconName: String?
    
    private let size: OLAIconImage
    
    private let padding: CGFloat

    
    // MARK: - Initializers
    
    public init(_ iconName: String?, size: OLAIconImage, padding: CGFloat = 0) {
        self.iconName = iconName
        self.size = size
        self.padding = padding
    }
    
    public init(_ icon: IconName?, size: OLAIconImage, padding: CGFloat = 0) {
        self.init(icon?.rawValue, size: size, padding: padding)
    }
    
    // MARK: - View builder
    
    public var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .padding(.all, padding)
            .frame(width: size.rawValue, height: size.rawValue)
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

