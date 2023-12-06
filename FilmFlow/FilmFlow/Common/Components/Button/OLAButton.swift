//
// ©2020 SEAT, S.A. All rights reserved.
//
// This is file is part of a propietary app or framework.
// Unauthorized reproduction, copying or modification of this file is strictly prohibited.
//
// This code is proprietary and confidential.
//
// All the 3rd-party libraries included in the project are regulated by their own licenses.
//

import SwiftUI

public enum ButtonType {
    /// large
    case large
    /// small
    case small
}

public enum ButtonStyles {
    /// primary
    case primary
    /// secondary
    case secondary
    /// tertiary
    case tertiary
    /// noBorder
    case noBorder
}

/// Button view
public struct OLAButton: View {
    
    // MARK: - Constants
    
    private let BUTTON_HEIGHT: CGFloat = 48.0
    
    private let BUTTON_PADDING_LARGE: CGFloat = 15.5
    
    private let BUTTON_PADDING_SMALL: CGFloat = 11.5
    
    // MARK: - Fields
    
    private let title: String?
    
    private let leftIcon: IconName?
    
    private let rightIcon: IconName?
    
    private var iconColor: Color
    
    private var backgroundColor: Color
    
    private let buttonStyle: ButtonStyles
    
    private var textStyle: TextStyle
    
    private let type: ButtonType
    
    private let cornerRadius: CGFloat
    
    private let isDisabled: Bool
    
    private let isLoading: Bool
    
    private let fillParent: Bool
    
    private let action: () -> Void
    
    // MARK: - Initializers

    public init(title: String?,
                leftIcon: IconName? = nil,
                rightIcon: IconName? = nil,
                textStyle: TextStyle = .title,
                buttonStyle: ButtonStyles = .primary,
                type: ButtonType = .large,
                cornerRadius: CGFloat = 0.0,
                iconColor: Color = .primaryBrand,
                backgroundColor: Color = .backgroundDark,
                isDisabled: Bool = false,
                isLoading: Bool = false,
                fillParent: Bool = true,
                action: @escaping () -> Void) {
        self.title = title
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.buttonStyle = buttonStyle
        self.textStyle = textStyle
        self.type = type
        self.cornerRadius = cornerRadius
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.fillParent = fillParent
        self.action = action
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
    }
    

    // MARK: - View builder
    
    public var body: some View {
        
        HStack {
            Button (action: {
                action()
            }) {
                HStack(spacing: LayoutSpacing.extraSmall) {
                    if fillParent {
                        Spacer()
                    }
                    
                    if leftIcon != nil {
                        OLAIcon(leftIcon, size: .small, color: iconColor)
                    }
                    
                    OLAText(title, style: textStyle).fixedSize(horizontal: false, vertical: true)
                    
                    if rightIcon != nil {
                        OLAIcon(rightIcon, size: .small, color: iconColor)
                    }
                    
                    if fillParent {
                        Spacer()
                    }
                }
                .padding(type == .large ? BUTTON_PADDING_LARGE : BUTTON_PADDING_SMALL)
            }
            .disabled( isDisabled || isLoading)
            .modifier(ButtonViewModifier(isDisabled: isDisabled, buttonStyle: buttonStyle, buttonType: type, cornerRadius: cornerRadius, backgroundColor: backgroundColor))
        }
    }
}


/// Primary Button Modifier
struct ButtonViewModifier: ViewModifier {
    
    private let disabled: Bool
    private let style: ButtonStyles
    private let type: ButtonType
    private let cornerRadius: CGFloat
    private let backgroundColor: Color
    
    /// Initializes a new instance
    public init(isDisabled disabled: Bool? = false, buttonStyle: ButtonStyles, buttonType: ButtonType, cornerRadius: CGFloat, backgroundColor: Color ) {
        // Required initialiazer to be visible between modules
        self.disabled = disabled ?? false
        self.style = buttonStyle
        self.type = buttonType
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }

    /// Body function of view modifier
    /// - Parameter content: content view
    public func body(content: Content) -> some View {
                
        let opacity = disabled ? 0.4 : 1
        
        switch(style) {
        case .primary:
            return AnyView(content
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .opacity(opacity))
            
        case .secondary:
            return AnyView(content
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .opacity(opacity))
        
        case .tertiary:
            return AnyView(content
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .opacity(opacity))
            
        case .noBorder:
            return AnyView(content)
        }
    }
}
