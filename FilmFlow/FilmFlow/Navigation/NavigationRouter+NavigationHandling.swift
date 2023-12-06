//
//  NavigationRouter+NavigationHandling.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import Foundation
import UIKit
// MARK: - Navigation handling
extension NavigationRouter {
    /// Navigates to given path
    /// - Parameters:
    ///   - path: Path to navigate to
    ///   - parameters: Parameters of the navigation
    ///   - replace:    Whether to replace the stack or not
    ///   - externally: Whether the navigation was launched externally or not. Defaults to false.
    ///   - embedInNavigationView: Whether to embed the view in a NavigationView or not
    ///   - modal: Whether to present navigation as modal or not
    ///   - shouldPreventDismissal: Whether modal dismissal should be prevented or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Animation to use for navigation
    public func navigate(toPath path: String,
                         withParameters parameters: [String : Any] = [:],
                         replace: Bool = false,
                         externally: Bool = false,
                         embedInNavigationView: Bool = true,
                         modal: Bool = false,
                         fullscreenModal: Bool = false,
                         shouldPreventDismissal: Bool = false,
                         interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
                         animation: NavigationTransition? = nil,
                         file: String = #fileID,
                         function: String = #function,
                         line: Int = #line,
                         completionHandler: @escaping (Bool) -> Void = { _ in }) {
#if canImport(Wormholy)
        Storage.shared.saveRequest(request: .init(name: "Navigate to \(path)\nfile: \(file) \nfunction: \(function) \nline: \(line)"))
#endif

        guard currentNavigationPath != path else { return }
        
        self.dispatchQueueBackground.async {
            self.currentNavigationPath = path
            
            let handler: (Bool) -> Void = { value in
                self.currentNavigationPath = nil
                completionHandler(value)
            }
            
            self.checkNavigationRequirementsAndNavigate(toPath: path,
                                                        withParameters: parameters,
                                                        replace: replace,
                                                        externally: externally,
                                                        embedInNavigationView: embedInNavigationView,
                                                        modal: modal,
                                                        fullscreenModal: fullscreenModal,
                                                        shouldPreventDismissal: shouldPreventDismissal,
                                                        interceptionExecutionFlow: interceptionExecutionFlow,
                                                        animation: animation,
                                                        completionHandler: handler)
        }
    }
    
    /// Whether the router can navigate to a given path or not
    /// - Parameter path: Path to navigate to
    /// - Parameter externally: Whether the navigation is coming externally or not
    public func canNavigate(toPath path: String,
                            externally: Bool = false) -> Bool {
        // Check if it is an external url and let the system handle it
        guard path.starts(with: "/") else {
            if let url: URL = URL(string: path), UIApplication.shared.canOpenURL(url) {
                return true
            }
            return false
        }
        
        // Check for a route matching given path
        guard let route: NavigationRoute = self.routes.first(where: {
            self.path(path, matchesRoutePath: $0.path)
        }) else {
            // Let the authentication handler handle callback URL if applicable
            if let callbackUrl: URL = URL(string: path),
                self.authenticationHandler?.canHandleCallbackUrl(callbackUrl) ?? false {
                return true
            }
            
            // Non-registered route and given path is not the callback URL for authorization
            return false
        }
        
        // Ensure route can be launched externally if it is coming from a deeplink
        guard !externally || route.allowedExternally else {
            // Do nothing, external navigation not allowed for given path
            return false
        }
        
        // Ensure authentication is available
        guard !route.requiresAuthentication || self.authenticationHandler != nil else {
            return false
        }
        
        return true
    }
    
    /// Dismisses modal if needed
    public func dismissModalIfNeeded(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            // Get root controller from active scene
            guard let keyWindow: UIWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene})
                .compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first,
                let rootViewController = keyWindow.rootViewController else {
                    return
            }
            
            rootViewController.presentedViewController?.dismiss(animated: true, completion: completion)
        }
    }
}

