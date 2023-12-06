//
//  HomeView.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 29/11/23.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
  
        VStack {
            Text("Profile View")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileWireframe().view
    }
}
