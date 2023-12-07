
import UIKit

class SplashWireframe {
    
    // MARK: - Properties
    
    /* Set path to navigate, lowercased, with "/" before the text and removing all suffix or prefix
     Example - static var path = "/home" */
    
    // static var path = "/yourModuleName"
    
    var parameters: [String: Any]?
    
    var view: SplashView {
        SplashView(viewModel: viewModel)
    }
    
    private var viewModel: SplashViewModel {
        let viewModel = SplashViewModel()
        viewModel.set(dataManager: dataManager, parameters: parameters)
        return viewModel
    }
    
    private var dataManager: SplashDataManager {
        SplashDataManager(apiClient: apiClient)
    }
    
    private var apiClient: SplashAPIClient {
        SplashAPIClient()
    }
    
    func getView(parameters: [String: Any]? = nil) -> UIViewController {
        self.parameters = parameters
        return view.asUIViewController()
    }
    
}
