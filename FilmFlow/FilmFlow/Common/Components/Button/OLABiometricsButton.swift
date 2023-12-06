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
//import MySEATUITheme
//
//public struct OLABiometricsButton: View {
//    
//    // MARK: - Fields
//    
//    private let title: String?
//    
//    private let shouldShowTitle: Bool
//    
//    private let shouldShowIcon: Bool
//    
//    private let iconName: OLAIconName?
//    
//    private let style: ButtonStyles
//    
//    private let type: ButtonType
//    
//    private let shouldApplySpace: Bool
//    
//    @State var isShowingAlert: Bool = false
//    
//    @Binding var unlocked: Bool
//    
//    @Binding var showModalSPIN: Bool
//    
//    @ObservedObject var biometricsViewModel = OLABiometrics()
//    
//    // MARK: - Initializer
//    
//    public init(title: String? = nil,
//                shouldShowTitle: Bool = true,
//                iconName: OLAIconName? = nil,
//                style: ButtonStyles = .tertiary,
//                type: ButtonType = .large,
//                shouldShowIcon: Bool = false,
//                shouldApplySpace: Bool = true,
//                unlocked: Binding<Bool>,
//                showModalSPIN: Binding<Bool> = .constant(false)) {
//        self.title = title
//        self.shouldShowTitle = shouldShowTitle
//        self.iconName = iconName
//        self.shouldShowIcon = shouldShowIcon
//        self.style = style
//        self.type = type
//        self.shouldApplySpace = shouldApplySpace
//        self._unlocked = unlocked
//        self._showModalSPIN = showModalSPIN
//    }
//    
//    // MARK: - View builder
//    
//    public var body: some View {
//        HStack(){
//            if #available(iOS 15.0, *) {
//                content
//                    .alert(alertTitle.localize(),
//                        isPresented: $isShowingAlert,
//                        actions: {
//                            Button(action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)},
//                                   label: { Text(settingsText.localize()) })
//                    
//                            Button(action: { self.showModalSPIN = false },
//                                   label: { Text(cancelText.localize()) })
//                    
//                        },
//                        message: { Text(alertMessage.localize()) })
//                    
//            } else { ///app supports since IOS 14.0 version
//                content
//                    .alert(isPresented: self.$isShowingAlert) {
//                        Alert(title: Text(alertTitle.localize()),
//                          message: Text(alertMessage.localize()),
//                          primaryButton: .default(Text(settingsText.localize()),
//                                                  action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)}),
//                          secondaryButton: .default(Text(cancelText.localize()),
//                                                    action: { self.showModalSPIN = false }))
//                        
//                    }
//            }
//        }
//    }
//    
//    private var bioTitle: String {
//        guard let title else { return "" }
//        
//        return title
//    }
//    
//    private var alertTitle: String {
//        switch biometricsViewModel.biometricalType() {
//        case .touchID:
//            if biometricsViewModel.authorizationError?.code == -8 {
//                return "CUPRAApp_MOD3_TouchID_NativeNotification_FifthTry_Error_iOS_TitleTouchIDBlocked"
//            } else {
//                return "CUPRAApp_MOD3_Touchid_NativeNotification_TouchIdDisabled_IOS_TitleTouchIDDisabled"
//            }
//            
//        default:
//            if biometricsViewModel.authorizationError?.code == -8 {
//                return "CUPRAApp_MOD3_Faceid_NativeNotification_FaceidBlocked_IOS_TitleFaceIDBlocked"
//            } else {
//                return "CUPRAApp_MOD3_Faceid_NativeNotification_FaceIdDisabled_IOS_TitleFaceIDDisabled"
//            }
//        }
//    }
//    
//    private var alertMessage: String {
//        switch biometricsViewModel.biometricalType() {
//        case .touchID:
//            if biometricsViewModel.authorizationError?.code == -8 {
//                return "CUPRAApp_MOD3_TouchID_NativeNotification_FifthTry_Error_iOS_TextTouchIDBlocked"
//            } else {
//                return "CUPRAApp_MOD3_Touchid_NativeNotification_TouchIdDisabled_IOS_TextTouchIDDisabled"
//            }
//            
//        default:
//            if biometricsViewModel.authorizationError?.code == -8 {
//                return "CUPRAApp_MOD3_Faceid_NativeNotification_FaceidBlocked_IOS_TextFaceIDBlocked"
//            } else {
//                return "CUPRAApp_MOD3_Faceid_NativeNotification_FaceIdDisabled_IOS_TextFaceIDDisabled"
//            }
//            
//            
//        }
//    }
//    
//    private var settingsText: String {
//        return "CUPRAApp_MOD3_Touchid_NativeNotification_TouchIdDisabled_IOS_ButtonSettings"
//    }
//    
//    private var cancelText: String {
//        return "CUPRAApp_MOD3_TouchID_NativeNotification_FirstTryNative_iOS_ButtonCancel"
//    }
//    
//    @ViewBuilder internal var content: some View {
//        OLAButton(title: shouldShowTitle ? bioTitle : nil,
//                  leftIcon: shouldShowIcon ? iconName : nil,
//                  style: style,
//                  type: type,
//                  fillParent: shouldApplySpace) {
//            
//            biometricsViewModel.requestBiometricUnlock()
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                if biometricsViewModel.appUnlocked {
//                    self.unlocked = true
//                } else {
//                    if let codeError = BiometricError(rawValue: biometricsViewModel.authorizationError?.code ?? 0) {
//                        if codeError == .notEnrolled || codeError == .notAvailable || codeError == .blocked {
//                            self.isShowingAlert = true
//                        }
//                    }
//                }
//            }
//        }.onChange(of: biometricsViewModel.authorizationError) { _ in
//            if let codeError = BiometricError(rawValue: biometricsViewModel.authorizationError?.code ?? 0),
//               codeError == .userCancel {
//                self.showModalSPIN = false
//            }
//        }
//    }
//}
