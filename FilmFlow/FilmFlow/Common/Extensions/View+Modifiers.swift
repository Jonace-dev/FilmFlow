//
//  View+Modifiers.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 11/12/23.
//

import Foundation
import SwiftUI

extension View {
    
    public func olaNavigationBar(_ title: String,
                                 displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View {
        
        let navigationText = title
        return Group {
            if #available(iOS 16.0, *) {
                self.navigationTitle(Text(navigationText))
                    .navigationBarTitleDisplayMode(displayMode)
                    .navigationBarHidden(false)
            } else {
                self.navigationBarTitle(navigationText, displayMode: displayMode)
            }
        }
    }
        

}

