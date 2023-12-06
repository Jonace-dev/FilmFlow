//
//  NavigationRouter+PrivateHelpers.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import Foundation
import UIKit

// MARK: - Private helpers
extension NavigationRouter {
    /// Checks navigation requirements and navigates to given path
    /// - Parameter path: Path to navigate to
    /// - parameter parameters: Parameters of the navigation
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether the navigation was launched externally or not
    /// - Parameter embedInNavigationView: Whether to embed the view in a NavigationView or not
    /// - Parameter modal: Whether to present the view as modal or not
    /// - Parameter shouldPreventDismissal: Whether modal dismissal should be prevented or not
    /// - Parameter interceptionExecutionFlow: Navigation interception execution flow (if any)
    /// - Parameter animation: Animation to use for navigation
    internal func checkNavigationRequirementsAndNavigate(toPath path: String,
                                                         withParameters parameters: [String: Any],
                                                         replace: Bool,
                                                         externally: Bool,
                                                         embedInNavigationView: Bool = true,
                                                         modal: Bool = false,
                                                         fullscreenModal: Bool = false,
                                                         shouldPreventDismissal: Bool = false,
                                                         interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
                                                         animation: NavigationTransition? = nil,
                                                         completionHandler: @escaping (Bool) -> Void) {
        // Check if it is an external url and let the system handle it
        guard path.starts(with: "/") else {
            DispatchQueue.main.async {
                if let url: URL = URL(string: path), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
                }
            }
            return
        }
        
        // Check for a route matching given path
        guard let route: NavigationRoute = self.routes.first(where: {
            self.path(path, matchesRoutePath: $0.path)
        }) else {
            // Let the authentication handler handle callback URL if applicable
            if let callbackUrl: URL = URL(string: path),
                self.authenticationHandler?.canHandleCallbackUrl(callbackUrl) ?? false {
                DispatchQueue.global().async {
                    self.authenticationHandler?.handleCallbackUrl(callbackUrl)
                }
                return
            }
            
            // Non-registered route and given path is not the callback URL for authorization
            self.handleError(forPath: path, .nonRegisteredRoute, completionHandler: completionHandler)
            return
        }
        
        // Ensure route can be launched externally if it is coming from a deeplink
        guard !externally || route.allowedExternally else {
            // Do nothing, external navigation not allowed for given path
            completionHandler(false)
            return
        }
        
        // Parse parameters and navigate
        self.parseParametersAndNavigate(toRoute: route,
                                        withParameters: parameters,
                                        withPath: path,
                                        replace: replace,
                                        externally: externally,
                                        embedInNavigationView: embedInNavigationView,
                                        modal: modal,
                                        fullscreenModal: fullscreenModal,
                                        shouldPreventDismissal: shouldPreventDismissal,
                                        interceptionExecutionFlow: interceptionExecutionFlow,
                                        animation: animation,
                                        completionHandler: completionHandler)
    }
    
    /// Parses parameters and navigates
    /// - Parameters:
    /// - Parameter route: Route to navigate to
    /// - Parameter path: Path to navigate to
    /// - Parameter parameters: Parameters of the navigation
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether the navigation was launched externally or not
    /// - Parameter embedInNavigationView: Whether to embed the view in a NavigationView or not
    /// - Parameter modal: Whether to present the view as modal or not
    /// - Parameter shouldPreventDismissal: Whether modal dismissal should be prevented or not
    /// - Parameter interceptionExecutionFlow: Navigation interception execution flow (if any)
    /// - Parameter animation: Animation to use for navigation
    internal func parseParametersAndNavigate(toRoute route: NavigationRoute,
                                             withParameters parameters: [String : Any],
                                             withPath path: String,
                                             replace: Bool,
                                             externally: Bool,
                                             embedInNavigationView: Bool = true,
                                             modal: Bool = false,
                                             fullscreenModal: Bool = false,
                                             shouldPreventDismissal: Bool = false,
                                             interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
                                             animation: NavigationTransition? = nil,
                                             completionHandler: @escaping (Bool) -> Void) {
        var parameters = parameters
        
        // Parse additional parameters
        if let additionalParameters = self.path(path, toDictionaryForRoutePath: route.path) {
            parameters.merge(additionalParameters, uniquingKeysWith: { key, _ in key })
        }
        
        // Actually navigate to route
        self.navigate(toRoute: route,
                      withParameters: parameters,
                      originalPath: path,
                      replace: replace,
                      externally: externally,
                      embedInNavigationView: embedInNavigationView,
                      modal: modal,
                      fullscreenModal: fullscreenModal,
                      shouldPreventDismissal: shouldPreventDismissal,
                      interceptionExecutionFlow: interceptionExecutionFlow,
                      animation: animation,
                      completionHandler: completionHandler)
    }
    
    /// Navigates to given route with given parameters
    /// - Parameters:
    ///   - route: Route to navigate to
    ///   - parameters: Parameters to use for navigation
    ///   - originalPath: Original navigation path
    ///   - replace: Whether to replace the stack or not
    ///   - externally: Whether the navigation is coming from an external source or not
    ///   - embedInNavigationView: Whether to embed the navigated view into a NavigationView
    ///   - modal: Whether to show the navigated view as modal or not
    ///   - shouldPreventDismissal: Whether modal dismissal should be prevented or not
    ///   - ignoreInterceptorsBefore: Whether to ignore interceptors before navigating or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Animation to use for navigation
    internal func navigate(toRoute route: NavigationRoute,
                           withParameters parameters: [String: Any],
                           originalPath: String,
                           replace: Bool = false,
                           externally: Bool = false,
                           embedInNavigationView: Bool = true,
                           modal: Bool = false,
                           fullscreenModal: Bool = false,
                           shouldPreventDismissal: Bool = false,
                           ignoreInterceptorsBefore: Bool = false,
                           interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
                           animation: NavigationTransition? = nil,
                           completionHandler: @escaping (Bool) -> Void) {
        
        // Declare actual navigation flow
        let actualNavigationFlow: (() -> Void) = {
            // Always execute this on main thread since it is UI-related
            DispatchQueue.main.asyncAfter(deadline: .now() + (externally ? self.externalNavigationDelay : 0), execute: {
                self.instantiateViewControllerAndNavigate(toRoute: route,
                                                          withParameters: parameters,
                                                          originalPath: originalPath,
                                                          replace: replace,
                                                          embedInNavigationView: embedInNavigationView,
                                                          modal: modal,
                                                          fullscreenModal: fullscreenModal,
                                                          shouldPreventDismissal: shouldPreventDismissal,
                                                          interceptionExecutionFlow: interceptionExecutionFlow,
                                                          animation: animation,
                                                          completionHandler: completionHandler)
            })
        }
        
        // Check whether previous interceptors must be ignored or not
        guard !ignoreInterceptorsBefore else {
            actualNavigationFlow()
            return
        }
        
        // Let interceptors do their work before actually navigating to the original requested path
        self.routerWillNavigate(toRoute: route,
                                withParameters: parameters,
                                originalPath: originalPath,
                                replace: replace,
                                embedInNavigationView: embedInNavigationView,
                                modal: modal,
                                shouldPreventDismissal: shouldPreventDismissal,
                                completion: actualNavigationFlow,
                                animation: animation,
                                completionHandler: completionHandler)
    }
    
    /// Instantiates view controller and navigates
    /// - Parameters:
    ///   - route: Route to navigate to
    ///   - parameters: Parameters to use for navigation
    ///   - originalPath: Original navigation path
    ///   - replace: Whether to replace the stack or not
    ///   - embedInNavigationView: Whether to embed the navigated view into a NavigationView
    ///   - modal: Whether to show the navigated view as modal or not
    ///   - shouldPreventDismissal: Whether modal dismissal should be prevented or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Animation to use for navigation
    // swiftlint:disable:next function_body_length
    internal func instantiateViewControllerAndNavigate(toRoute route: NavigationRoute,
                                                       withParameters parameters: [String: Any],
                                                       originalPath: String,
                                                       replace: Bool = false,
                                                       embedInNavigationView: Bool = true,
                                                       modal: Bool = false,
                                                       fullscreenModal: Bool = false,
                                                       shouldPreventDismissal: Bool = false,
                                                       interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
                                                       animation: NavigationTransition? = nil,
                                                       completionHandler: @escaping (Bool) -> Void) {
        // Check for authentication level
        guard !route.requiresAuthentication || self.isUserAuthenticated else {
           guard let authenticationHandler: RouterAuthenticationHandler = self.authenticationHandler else {
            self.handleError(forPath: originalPath, .unauthorized, completionHandler: completionHandler)
               return
           }
           
           self.dispatchQueueBackground.async {
#if DEBUG
           print("Route \(originalPath) requires user to be authenticated. Requesting authentication...")
#endif
               authenticationHandler.login(completion: {
                   self.dispatchQueueBackground.async {
                       self.navigate(toPath: originalPath,
                                     replace: replace,
                                     embedInNavigationView: embedInNavigationView,
                                     modal: modal,
                                     shouldPreventDismissal: shouldPreventDismissal,
                                     interceptionExecutionFlow: interceptionExecutionFlow,
                                     animation: animation,
                                     completionHandler: completionHandler)
                   }
               })
           }
           return
        }
        
        // Instantiate view model
        var viewModel = route.viewModelType.init()
        
        // Set navigation interception execution flow (if any)
        viewModel.navigationInterceptionExecutionFlow = interceptionExecutionFlow

        // Get root controller from active scene
        guard let keyWindow = self.activeWindow, let rootViewController = keyWindow.rootViewController else {
            self.handleError(forPath: originalPath, .inactiveScene, completionHandler: completionHandler)
            return
        }

        // Choose modal view controller (if any) instead of root view
        // to be able to navigate in modals
        let topRootViewController: UIViewController = rootViewController.presentedViewController ?? rootViewController
        
        // Create a hosting controller for instantiated view
        let hostedViewController: UIViewController = viewModel.makeView(parameters: parameters)
#if DEBUG
        hostedViewController.view.accessibilityIdentifier = originalPath
#endif
        
        // Push hosted view
        if modal {
            let modalViewController: UIViewController =
                embedInNavigationView ? UINavigationController(rootViewController: hostedViewController)
                    : hostedViewController
            modalViewController.isModalInPresentation = shouldPreventDismissal
            if fullscreenModal {
                modalViewController.modalPresentationStyle = .fullScreen
                modalViewController.modalTransitionStyle = .crossDissolve
            }
            
            keyWindow.rootViewController?.present(
                modalViewController,
                animated: true,
                completion: nil)
        } else if replace {
            if embedInNavigationView {
                self.setRootViewController(forWindow: keyWindow,
                                           UINavigationController(rootViewController: hostedViewController),
                                           animation: animation)
            } else {
                self.setRootViewController(forWindow: keyWindow, hostedViewController, animation: animation)
            }
        } else if let navigationController: UINavigationController = topRootViewController.navigationController {
                navigationController.pushViewController(hostedViewController,
                                                        animated: true)
        } else if let navigationController: UINavigationController = topRootViewController as? UINavigationController {
            navigationController.pushViewController(hostedViewController, animated: true)
        } else if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(hostedViewController, animated: true)
        } else if embedInNavigationView {
            self.setRootViewController(forWindow: keyWindow,
                                       UINavigationController(rootViewController: hostedViewController),
                                       animation: animation)
        } else {
            self.setRootViewController(forWindow: keyWindow, hostedViewController, animation: animation)
        }
        
        completionHandler(true)
        
        // Let post-navigation interceptors do their work
        DispatchQueue.main.async {
            self.routerDidNavigate(toRoute: route,
                                   withParameters: parameters,
                                   originalPath: originalPath,
                                   replace: replace,
                                   embedInNavigationView: embedInNavigationView,
                                   modal: modal,
                                   shouldPreventDismissal: shouldPreventDismissal,
                                   animation: animation)
        }
    }
    
    /// Sets root view controller
    /// - Parameters:
    ///   - window: UIWindow instance
    ///   - viewController: UIViewController instance
    ///   - animation: Animation to use for transition
    private func setRootViewController(forWindow window: UIWindow,
                                       _ viewController: UIViewController,
                                       animation: NavigationTransition? = .left) {
        // Ensure we've got a valid animation, otherwise change it immediately
        guard animation != nil, animation != .some(.none) else {
            window.rootViewController = viewController
            return
        }
        
        var transitionOptions: UIWindow.TransitionOptions?
        switch animation {
        case .right:
            transitionOptions = .init(direction: .toLeft, style: .easeInOut)
        
        case .down:
            transitionOptions = .init(direction: .toBottom, style: .easeInOut)
            
        case .up:
            transitionOptions = .init(direction: .toTop, style: .easeInOut)
            
        default: // left
            transitionOptions = .init(direction: .toRight, style: .easeInOut)
        }
        
        if let transitionOptions = transitionOptions {
            window.setRootViewController(viewController, options: transitionOptions)
        }
        
        // Notify the change of root view contoller
        NotificationCenter.default.post(name: .onChangeRootViewController, object: nil)
    }
}
