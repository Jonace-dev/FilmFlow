//
//  View+UIHostingController.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import SwiftUI
import UIKit

// MARK: - UIHostingController

/// UIHostingController theme options
public class UIHostingControllerThemeOptions {
    /// Background color
    public static var defaultBackgroundColor: UIColor = .systemBackground
    
    /// Whether to remove back button text for all views or not
    public static var removeBackButtonText: Bool = false
    
    /// Whether to hide bars while scrolling
    public static var hideBarsWhileScrolling: Bool = false
}

/// Custom UITraitEnvironment protocol
public protocol TraitCollectionListener: AnyObject {
    /// Handles required actions when trait environment changes
    /// - Parameter previousTraitCollection: Previous trait collection
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
}

/// Custom UIHostingController
public class SEATUIHostingController<Content>: UIHostingController<Content> where Content: SwiftUI.View {
    // MARK: - Fields
    
    /// Trait environment
    private weak var traitEnvironment: TraitCollectionListener?
    
    // MARK: - Initializers
    
    /// Initializes a new instance
    /// - Parameter rootView: Root view (SwiftUI.View instance)
    /// - Parameter traitEnvironment: UITraitEnvironment instance
    public init(rootView: Content, traitEnvironment: TraitCollectionListener? = nil) {
        super.init(rootView: rootView)
        
        self.traitEnvironment = traitEnvironment
    }
    
    /// Initializes a new instance with given decoder
    /// - Parameter aDecoder: Decoder instance
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    
    /// Handles required actions when view is about to appear
    /// - Parameter animated: Whether to use animations or not
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Apply theme
        self.applyTheme()
        
        // Set back item title (if needed)
        self.setBackItemTitleIfNeeded()
        
        // Hide bars while scrolling (if needed)
        self.hideBarsWhileScrollingIfNeeded()
        
        // Adjust font of the navigationTitle to fit the width of the screen
        if let view = navigationController?.view, let label = findLabel(in: view) {
            label.adjustsFontSizeToFitWidth = true
        }
    }
    
    // MARK: - UITraitEnvironment
    
    /// Handles required actions when trait collection did change
    /// - Parameter previousTraitCollection: Previous trait collection
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Notify trait collection did change (if needed)
        self.traitEnvironment?.traitCollectionDidChange(previousTraitCollection)
    }
    
    // MARK: - Helpers
    
    /// Applies theme
    private func applyTheme() {
        // Override background color (UIColor.systemBackground can be overriden using method swizzling)
        self.view.backgroundColor = UIHostingControllerThemeOptions.defaultBackgroundColor
    }
    
    /// Sets back item title (if needed)
    private func setBackItemTitleIfNeeded() {
        // Check whether to remove back button text or not
        guard UIHostingControllerThemeOptions.removeBackButtonText else {
            return
        }
        
        // Remove back button text
        let backButtonItem: UIBarButtonItem = UIBarButtonItem()
        backButtonItem.title = ""
        self.navigationItem.backBarButtonItem = backButtonItem
    }
    
    /// Hides bars while scrolling (if needed)
    private func hideBarsWhileScrollingIfNeeded() {
        // Check whether we should hide bars while scrolling or not
        guard UIHostingControllerThemeOptions.hideBarsWhileScrolling else {
            return
        }
        
        // Hide bars while scrolling
        self.navigationController?.hidesBarsOnSwipe = true
        
        // Set interactive pop gesture recognizer to nil in order to
        // be able to go back with native gesture while hiding bars on swipe
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func findLabel(in view: UIView) -> UILabel? {
        for subview in view.subviews {
            if let label = findLabel(in: subview) { // recursively find the label
                return label
            }
        }
        
        return view as? UILabel
    }
}

/// Dark-status-bar-style UIHostingController
public class DarkStatusBarStyleUIHostingController<Content>: SEATUIHostingController<Content>
    where Content: SwiftUI.View {
    // MARK: - Environment fields
    
    /// Preferred status bar style
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

/// Light-status-bar-style UIHostingController
public class LightStatusBarStyleUIHostingController<Content>: SEATUIHostingController<Content>
    where Content: SwiftUI.View {
    // MARK: - Environment fields
    
    /// Preferred status bar style
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

/// Custom selection status bar style UIHostingController
public class CustomStatusBarStyleUIHostingController<Content>: SEATUIHostingController<Content>
    where Content: SwiftUI.View {
    // MARK: - Fields
    
    private var statusBarStyle: UIStatusBarStyle = .default
    
    // MARK: - Initializers
    
    /// Initializes a new instance
    /// - Parameter rootView: Root view (SwiftUI.View instance)
    /// - Parameter statusBarStyle: UIStatusBarStyle instance
    /// - Parameter traitEnvironment: UITraitEnvironment instance
    init(rootView: Content, statusBarStyle: UIStatusBarStyle, traitEnvironment: TraitCollectionListener? = nil) {
        self.statusBarStyle = statusBarStyle
        super.init(rootView: rootView, traitEnvironment: traitEnvironment)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Environment fields
    
    /// Preferred status bar style
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

/// This extension is intended to transform a SwiftUI.View into a UIKit.UIViewController easily
public extension SwiftUI.View {
    /// Returns current view as UIViewController
    func asUIViewController(
        traitEnvironment: TraitCollectionListener? = nil) -> UIViewController {
        return SEATUIHostingController(rootView: self, traitEnvironment: traitEnvironment)
    }
    
    /// Returns current view as UIViewController with dark status bar style
    func asUIViewControllerWithDarkStatusBarStyle(
        traitEnvironment: TraitCollectionListener? = nil) -> UIViewController {
        return DarkStatusBarStyleUIHostingController(rootView: self, traitEnvironment: traitEnvironment)
    }
    
    /// Returns current view as UIViewController with light status bar style
    func asUIViewControllerWithLightStatusBarStyle(
        traitEnvironment: TraitCollectionListener? = nil) -> UIViewController {
        return LightStatusBarStyleUIHostingController(rootView: self, traitEnvironment: traitEnvironment)
    }
    
    /// Returns current view as UIViewController with the chosen status bar style
    func asUIViewControllerWithCustomStatusBarStyle(
        style: UIStatusBarStyle,
        traitEnvironment: TraitCollectionListener? = nil) -> UIViewController {
        return CustomStatusBarStyleUIHostingController(rootView: self, statusBarStyle: style)
    }
}
