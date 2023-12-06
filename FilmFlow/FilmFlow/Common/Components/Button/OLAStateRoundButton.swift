////
//// ©2023 SEAT, S.A. All rights reserved.
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
//import SEATCore
//
//import MySEATUITheme
//
//public struct OLAStateRoundButton: View {
//    
//    // MARK: - Properties
//    
//    private let title: String
//    
//    private let titleStyle: OLATextStyle
//    
//    private let iconName: OLAIconName
//    
//    private let iconColor: Color
//    
//    private let iconSize: OLAIconSize
//    
//    private let backGroundColor: Color
//    
//    private let diameter: CGFloat
//    
//    private let state: OLAState
//    
//    private let action: OLACircularButtonAction
//    
//    // MARK: - Initializers
//    
//    public init(title: String,
//                titleStyle: OLATextStyle = .olaSFSmallHeader,
//                iconName: OLAIconName,
//                iconColor: Color = .olaPrimaryDark,
//                iconSize: OLAIconSize = .medium,
//                backGroundColor: Color = .olaSecondaryNeutral030,
//                diameter: CGFloat = 60.0,
//                state: OLAState,
//                action: @escaping OLACircularButtonAction) {
//        self.title = title
//        self.titleStyle = titleStyle
//        self.iconName = iconName
//        self.iconColor = iconColor
//        self.iconSize = iconSize
//        self.backGroundColor = backGroundColor
//        self.diameter = diameter
//        self.state = state
//        self.action = action
//    }
//    
//    // MARK: - View Builders
//    
//    public var body: some View {
//        VStack(spacing: OLALayoutSpacing.small) {
//            Button {
//                action(state.isOn)
//            } label: {
//                ZStack() {
//                    Circle()
//                        .fill(backGroundColor)
//                        .frame(width: diameter, height: diameter, alignment: .center)
//                        .overlay(
//                            VStack {
//                                if state.isSyncronizing {
//                                    OLACircularLoader(lineWidth: 2.0,
//                                                      lineColor: .olaPrimaryBrand,
//                                                      lineBackgroundColor: .clear,
//                                                      animationDuration: 1.5,
//                                                      animationTrim: 0.75)
//                                }
//                            }
//                        )
//                    
//                    OLAIcon(iconName, size: iconSize, color: iconColor)
//                }
//            }
//            .animation(.easeIn, value: state)
//            .opacity(state.isSyncronizingOrDisabled ? 0.5 : 1.0)
//            .disabled(state.isSyncronizing || state == .disabledOn)
//            
//            OLAText(title, style: titleStyle)
//                .opacity(state.isSyncronizingOrDisabled ? 0.5 : 1.0)
//        }
//    }
//}
//
//// MARK: - Typealiases
//
//extension OLAStateRoundButton {
//    public typealias OLACircularButtonAction = (_ isOn: Bool) -> Void
//}
