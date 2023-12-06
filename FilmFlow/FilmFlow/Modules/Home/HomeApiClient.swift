//
//  HomeApiClient.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 29/11/23.
//

import Foundation
import Alamofire
import Combine

class HomeApiClient: BaseApiClient {

    func getTrendingMovies() -> AnyPublisher<TrendingMoviesResponse, BaseError> {
        requestPublisher(Endpoints.trendingMoviesWeek, type: TrendingMoviesResponse.self)
    }
    
}
