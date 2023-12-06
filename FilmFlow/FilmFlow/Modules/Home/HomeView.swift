//
//  HomeView.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 29/11/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Hola mundo")
            
        }.onAppear {
            viewModel.getTrendingMovies()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeWireframe().homeView
    }
}
