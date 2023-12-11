
import Foundation
import Alamofire
import Combine

class ChangeAccountDataManager {
    
    // MARK: - Properties
    
    private var apiClient: ChangeAccountAPIClient
    
    
    // MARK: - Object lifecycle
    
    init(apiClient: ChangeAccountAPIClient) {
        self.apiClient = apiClient
    }
    
    
    // MARK: - Public Methods
    
    /* Call example with combine */
    
//    func getTrendingMovies() -> AnyPublisher<TrendingMoviesResponse, BaseError> {
//        homeApiClient.getTrendingMovies()
//            .tryMap { moviesResponse in
//                return moviesResponse
//            }
//            .mapError({ error in
//                return error as? BaseError ??  BaseError.generic
//            })
//            .eraseToAnyPublisher()
//    }
}
