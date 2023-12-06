////
//// ©2022 SEAT, S.A. All rights reserved.
////
//// This is file is part of a propietary app or framework.
//// Unauthorized reproduction, copying or modification of this file is strictly prohibited.
////
//// This code is proprietary and confidential.
////
//// All the 3rd-party libraries included in the project are regulated by their own licenses.
////
//
//import SwiftUI
//
//import MySEATUITheme
//
//public struct OLAFloatingButton: View {
//    // MARK: - Constants
//    
//    private let DIAMETER: CGFloat = 50
//    
//    // MARK: - Properties
//    
//    private let iconName: OLAIconName
//    
//    private let iconColor: Color
//    
//    private let xOffset: CGFloat
//    
//    private let yOffset: CGFloat
//    
//    private let action: () -> Void
//    
//    @Environment(\.colorScheme) private var colorScheme
//    
//    // MARK: - Initializers
//    
//    internal init(iconName: OLAIconName,
//                  iconColor: Color,
//                  xOffset: CGFloat = .zero,
//                  yOffset: CGFloat = .zero,
//                  action: @escaping () -> Void) {
//        self.iconName = iconName
//        self.iconColor = iconColor
//        self.xOffset = xOffset
//        self.yOffset = yOffset
//        self.action = action
//    }
//    
//    public init(iconName: OLAIconName, iconColor: Color, action: @escaping () -> Void) {
//        self.iconName = iconName
//        self.iconColor = iconColor
//        self.xOffset = .zero
//        self.yOffset = .zero
//        self.action = action
//    }
//    
//    // MARK: - View builders
//    
//    public var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color.olaPrimaryLight)
//                .frame(width: DIAMETER, height: DIAMETER, alignment: .center)
//                .shadow(color: .olaAlwaysSecondaryNeutral080, radius: shadowSize, x: .zero, y: shadowSize)
//            
//            Button(action: action) {
//                OLAIcon(iconName, size: .medium, color: iconColor)
//            }
//            .offset(x: xOffset, y: yOffset)
//        }
//    }
//    
//    // MARK: - Helpers
//    
//    private var shadowSize: CGFloat {
//        return colorScheme == .light ? 2 : .zero
//    }
//}
