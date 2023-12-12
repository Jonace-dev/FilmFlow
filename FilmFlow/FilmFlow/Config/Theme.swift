//
//  Theme.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 11/12/23.
//


import Foundation
import UIKit
import SwiftUI

/// Theme class
public final class Theme {
    // MARK: - Public constants
    
    /// Default layout margins
    //public static let defaultLayoutMargins: CGFloat = 20
    
    /// Theme bundle
    public static let bundle = Bundle.main

    // MARK: - Public methods
    
    /// Registers all the available fonts
    public static func registerFonts() {
        Fonts.allCases.forEach { font in
            UIFont.registerFont(bundle: bundle, fontName: font.fontName)
        }
    }

    /// Applies theme
    public static func apply() {
        // Setup UINavigationBar appearance
        //setupNavigationBarAppearance()
        configNavBar()

//        // Setup UIBarButtonItem appearance
//        setupBarButtonItemAppearance()
//
//        // Setup UISwitch appearance
//        setupSwitchAppearance()
//        
//        // Set UITabBar appearance
//        setTabBarAppearance()
    }

    // MARK: - Private helpers

    /// Setups navigation bar appearance
    
    private static func configNavBar() {
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.olaNavigationTitle()
        ]
        
        // Show back button text clear
        let backButtonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.clear,
        ]
        
        var backButtonImage: UIImage = UIImage(named: "icn_arrow_back", in: bundle, compatibleWith: nil)!
        backButtonImage = backButtonImage.withTintColor(UIColor.secondaryWhite, renderingMode: .alwaysOriginal)
        backButtonImage = backButtonImage.withBaselineOffset(fromBottom: 13)
        
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.focused.titleTextAttributes = backButtonAttributes
        backButtonAppearance.disabled.titleTextAttributes = backButtonAttributes
        backButtonAppearance.highlighted.titleTextAttributes = backButtonAttributes
        backButtonAppearance.normal.titleTextAttributes = backButtonAttributes

      
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.backgroundDark
        navigationBarAppearance.titleTextAttributes = textAttributes
        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        navigationBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = nil
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = UIColor.secondaryWhite
        UINavigationBar.appearance().isTranslucent = true
    
    }

//    /// Setups bar button item appearance
//    private static func setupBarButtonItemAppearance() {
//        UIBarButtonItem.appearance().setTitleTextAttributes([
//            .font: UIFont.olaRegularNavigation(size: 16)
//        ], for: .normal)
//    }
//
//    /// Setups switch appearance
//    private static func setupSwitchAppearance() {
//        UISwitch.appearance().onTintColor = UIColor.olaPrimaryBrand
//    }
//    
//    /// Sets tab bar appearance
//    private static func setTabBarAppearance() {
//        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().backgroundColor = .olaSecondaryNeutral040
//    }
}

