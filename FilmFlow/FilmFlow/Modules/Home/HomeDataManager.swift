//
//  HomeDataManager.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 29/11/23.
//

import Foundation
import Alamofire
import Combine

class HomeDataManager {
 
    var homeApiClient: HomeApiClient
    
    init(homeApiClient: HomeApiClient) {
        self.homeApiClient = homeApiClient
    }
    
    func getTrendingMovies() -> AnyPublisher<TrendingMoviesResponse, BaseError> {
        homeApiClient.getTrendingMovies()
            .tryMap { moviesResponse in
                return moviesResponse
            }
            .mapError({ error in
                return error as? BaseError ??  BaseError.generic
            })
            .eraseToAnyPublisher()
    }
    
    
}
