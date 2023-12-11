
import UIKit

class ChangeAccountWireframe {
    
    // MARK: - Properties
    
    /* Set path to navigate, lowercased, with "/" before the text and removing all suffix or prefix
     Example - static var path = "/home" */
    
    static var path = "/changeaccount"
    
    var parameters: [String: Any] = [:]
    
    var view: ChangeAccountView {
        ChangeAccountView(viewModel: viewModel)
    }
    
    private var viewModel: ChangeAccountViewModel {
        let viewModel = ChangeAccountViewModel()
        viewModel.set(dataManager: dataManager, parameters: parameters)
        return viewModel
    }
    
    private var dataManager: ChangeAccountDataManager {
        ChangeAccountDataManager(apiClient: apiClient)
    }
    
    private var apiClient: ChangeAccountAPIClient {
        ChangeAccountAPIClient()
    }
    
    func getView(parameters: [String: Any]) -> UIViewController {
        self.parameters = parameters
        return view.asUIViewController()
    }
    
}
