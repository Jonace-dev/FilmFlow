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
//import SEATCore
//
//import MySEATUITheme
//
//public struct OLAMotionButton: View {
//    // MARK: - Enumerations
//    
//    public enum Style {
//        case primary
//        case secondary
//        case tertiary
//    }
//    
//    // MARK: - Constants
//    
//    private let SKELETON_BUTTON_HEIGHT: CGFloat = 48
//    
//    private let PADDING_BUTTON: CGFloat = 15.5
//    
//    // MARK: - Typealiases
//    
//    public typealias OLAMotionButtonText = (on: String?, off: String?, syncronizing: String?)
//    
//    public typealias OLAMotionButtonSimplifiedText = (default: String?, syncronizing: String?)
//
//    public typealias OLAMotionButtonGradient = (on: LinearGradient?, off: LinearGradient?)
//
//    public typealias OLAMotionButtonAction = (_ isOn: Bool) -> Void
//    
//    // MARK: - Properties
//    
//    @Binding private var state: OLAState
//    
//    @State private var lastState: OLAState
//        
//    @State private var textOffset = 0
//    
//    @State private var textOpacityText = 1.0
//    
//    @State private var textDegreesUp = 0.0
//    
//    private let text: OLAMotionButtonText
//    
//    private let style: OLAMotionButton.Style
//    
//    private let action: OLAMotionButtonAction
//    
//    private var isLoading: Bool = false
//    
//    // MARK: - Initializers
//    
//    public init(state: Binding<OLAState>,
//                text: OLAMotionButtonText = (on: "Stop", off: "Start", syncronizing: "Syncronizing..."),
//                style: OLAMotionButton.Style = .primary,
//                action: @escaping OLAMotionButtonAction,
//                isLoading: Bool = false) {
//        self._state = state
//        self._lastState = State(initialValue: state.wrappedValue)
//        self.text = text
//        self.style = style
//        self.action = action
//        self.isLoading = isLoading
//    }
//    
//    public init(state: Binding<OLAState>,
//                text: String?,
//                style: OLAMotionButton.Style = .primary,
//                action: @escaping OLAMotionButtonAction,
//                isLoading: Bool = false) {
//        self.init(state: state, text: (on: text, off: text, syncronizing: text), style: style, action: action, isLoading: isLoading)
//    }
//    
//    public init(state: Binding<OLAState>,
//                text: OLAMotionButtonSimplifiedText,
//                style: OLAMotionButton.Style = .primary,
//                action: @escaping OLAMotionButtonAction,
//                isLoading: Bool = false) {
//        self.init(state: state,
//                  text: (on: text.default, off: text.default, syncronizing: text.syncronizing),
//                  style: style,
//                  action: action,
//                  isLoading: isLoading)
//    }
//    
//    // MARK: - View Builder
//    
//    public var body: some View {
//        Button {
//            action(state.isOn)
//        } label: {
//            OLAText(getText(for: state), style: textStyle)
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .offset(x: 0.0, y: CGFloat(textOffset))
//                .rotation3DEffect(.degrees(textDegreesUp), axis: (x: 1, y: 0, z: 0))
//                .opacity(textOpacityText)
//                .padding(PADDING_BUTTON)
//                .background(currentGradient)
//                .onChange(of: state) { newState in
//                    if lastState != newState, shouldAnimateNewState(newState) {
//                        executeMotion()
//                    }
//                    
//                    lastState = newState
//                }
//                .cornerRadius(2.0)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 2.0)
//                        .stroke(Color.olaPrimaryDark, lineWidth: style == .secondary ? 1 : 0)
//                )
//                .skeletonable(isLoading: isLoading, height: SKELETON_BUTTON_HEIGHT)
//        }
//        .buttonStyle(PlainButtonStyle())
//        .disabled(state.isSyncronizingOrDisabled)
//    }
//    
//    // MARK: - Helpers
//    
//    private var textStyle: OLATextStyle {
//        switch style {
//        case .primary, .tertiary:
//            return .olaButtonAlwaysWhite
//            
//        case .secondary:
//            return .olaButton
//        }
//    }
//    
//    private var gradient: OLAMotionButtonGradient {
//        switch style {
//        case .primary:
//            return (on: .olaTertiaryGradient, off: .olaPrimaryGradient)
//            
//        case .secondary:
//            return (on: nil, off: nil)
//            
//        case .tertiary:
//            return (on: .olaTertiaryGradient, off: .olaTertiaryGradient)
//        }
//    }
//    
//    private var currentGradient: LinearGradient? {
//        if state.isOn {
//            return gradient.on
//        } else {
//            return gradient.off
//        }
//    }
//    
//    private func shouldAnimateNewState(_ newState: OLAState) -> Bool {
//        return getText(for: lastState) != getText(for: newState)
//    }
//    
//    private func executeMotion() {
//        withAnimation(.easeOut(duration: 0.2)) {
//            textOffset = -20
//            textOpacityText = 0
//            textDegreesUp = 50
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            withAnimation(.none) {
//                textOffset = 20
//                textDegreesUp = -50
//            }
//            
//            
//            withAnimation(.easeOut(duration: 0.2)) {
//                textOffset = 0
//                textOpacityText = 1
//                textDegreesUp = 0
//            }
//        }
//    }
//    
//    private func getText(for state: OLAState) -> String? {
//        if state.isSyncronizing {
//            return text.syncronizing
//        } else if state.isOn {
//            return text.on
//        } else {
//            return text.off
//        }
//    }
//}
