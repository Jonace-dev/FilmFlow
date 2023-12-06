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
//public struct OLARoundedButton: View {
//    
//    // MARK: - Constants
//    
//    private let ANIMATION_DURATION = 1.0
//    
//    private let MAX_DEGREES = 360.0
//    
//    // MARK: - Properties
//    
//    private let title: String?
//    
//    private let icon: OLAIconName?
//    
//    private let isDisabled: Bool
//    
//    private var action: () -> Void
//    
//    private var backgroundColor: Color?
//    
//    private var maxWidthRequired: Bool = false
//        
//    private var borderColor: Color?
//    
//    private var borderWidth: CGFloat?
//    
//    @Binding private var rotating: Bool
//    
//    // MARK: - Initializers
//    
//    public init(title: String?, icon: OLAIconName? = nil, isDisabled: Bool = false, background: Color? = nil, maxWidthRequired: Bool = false, borderWidth: CGFloat? = nil, borderColor: Color? = nil, rotate: Binding<Bool> = .constant(false), action: @escaping () -> Void) {
//        self.title = title
//        self.icon = icon
//        self.isDisabled = isDisabled
//        self.action = action
//        self.backgroundColor = background
//        self.maxWidthRequired = maxWidthRequired
//        self.borderColor = borderColor
//        self.borderWidth = borderWidth
//        self._rotating = rotate
//    }
//    
//    // MARK: Body builder
//    
//    public var body: some View {
//        Button(action: action) {
//            HStack(spacing: OLALayoutSpacing.small) {
//                if maxWidthRequired {
//                    Spacer()
//                }
//                if icon != nil {
//                    OLAIcon(icon, size: .small, color: .olaPrimaryDark)
//                        .rotationEffect(Angle(degrees: rotating ? MAX_DEGREES : .zero))
//                        .animation(.linear(duration: rotating ? ANIMATION_DURATION : .zero)
//                                    .repeatCount(rotating ? Int.max : .zero, autoreverses: false),
//                                   value: rotating)
//                }
//                
//                OLAText(title, style: .olaSFSmallHeader)
//                if maxWidthRequired {
//                    Spacer()
//                }
//            }
//            .padding(.vertical, OLALayoutSpacing.small)
//            .padding(.horizontal, OLALayoutSpacing.medium)
//            .background(backgroundColor ?? Color.olaPrimaryLight)
//            .cornerRadius(18)
//            .overlay(
//                RoundedRectangle(cornerRadius: 18)
//                    .stroke(lineWidth: borderWidth ?? 1)
//                    .foregroundColor(borderColor ?? .olaPrimaryDark)
//            )
//        }
//        .opacity(isDisabled ? 0.2 : 1)
//        .disabled(isDisabled)
//    }
//}
