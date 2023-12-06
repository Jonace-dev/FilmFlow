////
//// ©2020 SEAT, S.A. All rights reserved.
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
//public enum OLALinkButtonType {
//    case small
//    case large
//    case custom(_ style: OLATextStyle)
//}
//
//public struct OLALinkButton: View {
//    // MARK: - Typealiases
//    
//    public typealias OLALinkButtonAction = () -> Void
//    
//    // MARK: - Constants
//    
//    private let DISABLED_OPACITY: Double = 0.4
//    
//    // MARK: - Properties
//    
//    /// Button title
//    private let title: String?
//    
//    /// True if OLALinkButton is disabled; false otherwise
//    private let isDisabled: Bool
//    
//    /// True if arrow should be displayed; false otherwise
//    private let shouldShowArrow: Bool
//    
//    /// Button type
//    private let type: OLALinkButtonType
//    
//    /// Arrow color
//    private let arrowColor: Color
//    
//    private let arrowIcon: OLAIconName
//    
//    /// Button action
//    private var action: OLALinkButtonAction?
//    
//    // MARK: - Initializers
//
//    public init(_ title: String?,
//                shouldShowArrow: Bool = true,
//                isDisabled: Bool = false,
//                type: OLALinkButtonType = .large,
//                arrowColor: Color = .olaPrimaryDark,
//                arrowIcon: OLAIconName = .arrowRightSmall,
//                action: OLALinkButtonAction? = nil) {
//        self.title = title
//        self.isDisabled = isDisabled
//        self.shouldShowArrow = shouldShowArrow
//        self.type = type
//        self.arrowColor = arrowColor
//        self.arrowIcon = arrowIcon
//        self.action = action
//    }
//    
//    // MARK: - View Builder
//    
//    public var body: some View {
//        HStack {
//            if let action = action {
//                Button(action: action) { linkButtonContent }
//            } else {
//                linkButtonContent
//            }
//        }
//        .disabled(isDisabled)
//        .opacity(isDisabled ? DISABLED_OPACITY : 1)
//    }
//    
//    // MARK: - Helpers
//    
//    private var linkButtonContent: some View {
//        HStack(spacing: OLALayoutSpacing.ultraSmall) {
//            OLAText(title, style: textStyle)
//            
//            if shouldShowArrow {
//                OLAIcon(arrowIcon, size: .small, color: arrowColor)
//            }
//        }
//        .padding(.vertical, OLALayoutSpacing.small)
//        .padding(.horizontal, OLALayoutSpacing.smallMedium)
//    }
//    
//    private var textStyle: OLATextStyle {
//        switch type {
//        case .large:
//            return .olaButton
//            
//        case .small:
//            return .olaSmallButton
//            
//        case .custom(let style):
//            return style
//        }
//    }
//}
//
