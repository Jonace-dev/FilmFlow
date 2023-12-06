//
//  MoviesResponse.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 30/11/23.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    let results: [TrendingMovie]
}

struct TrendingMovie: Codable {
    let title: String?
    let id: Int?
    let adult: Bool?
    let poster_path: String?
    
}

