//
//  NavigationRouter+NavigationInterception.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 5/12/23.
//

import Foundation

/// Navigation interception enum
public enum NavigationInterceptorPoint: Int, Codable {
    /// Before navigating
    case before
    
    /// After navigating
    case after
}

/// Navigation interception priority
public enum NavigationInterceptionPriority: Int, Codable, Comparable {
    case none
    case veryLow
    case low
    case medium
    case high
    case veryHigh
    case mandatory
    
    // MARK: - Comparable
    
    /// Compares two given instances
    /// - Parameters:
    ///   - lhs: First instance to compare
    ///   - rhs: Second instance to compare
    public static func < (lhs: NavigationInterceptionPriority, rhs: NavigationInterceptionPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/// Navigation interceptor recurrence
public enum NavigationInterceptorRecurrence {
    /// Interceptor should be executed only once per installation
    case oncePerInstallation
    
    /// Interceptor should be executed only once per execution
    case oncePerExecution
    
    /// Interceptor should be always executed
    case always
}

/// Navigation interceptor
internal struct NavigationInterceptor: Comparable {
    // MARK: - Fields
    
    /// Identifier
    internal var id: String
    
    /// Path
    internal var path: String
    
    /// Handler
    internal var handler: ((((Bool?) -> Void)?) -> Void)?
    
    /// Navigation interceptor point
    internal var when: NavigationInterceptorPoint
    
    /// Priority
    internal var priority: NavigationInterceptionPriority
    
    /// Recurrence
    internal var recurrence: NavigationInterceptorRecurrence
    
    /// Whether the interceptor requires authentication or not
    internal var requiresAuthentication: Bool
    
    internal var queue: NavigationRouter.InterceptorQueue

    // MARK: - Comparable
    
    /// Compares given instances
    /// - Parameters:
    ///   - lhs: First instance
    ///   - rhs:Second instance
    static func < (lhs: NavigationInterceptor, rhs: NavigationInterceptor) -> Bool {
        // Order by authentication
        if lhs.requiresAuthentication != rhs.requiresAuthentication {
            return lhs.requiresAuthentication
        }
        
        // Order by priority
        if lhs.priority > rhs.priority {
            return false
        }
        
        // In any other case, lhs < rhs
        return true
    }
    
    /// Gets whether two given instances are equal or not
    /// - Parameters:
    ///   - lhs: First instance
    ///   - rhs: Second instance
    static func == (lhs: NavigationInterceptor, rhs: NavigationInterceptor) -> Bool {
        return lhs.path == rhs.path &&
            lhs.when == rhs.when &&
            lhs.priority == rhs.priority &&
            lhs.requiresAuthentication == rhs.requiresAuthentication
    }
}

/// Navigation interception flow
public struct NavigationInterceptionFlow {
    // MARK: - Fields
    
    /// Completion handler to continue flow execution (if any)
    public var `continue`: ((Bool?) -> Void)?
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given completion handler
    /// - Parameter completion: Completion handler to continue execution (if any)
    public init(completion: ((Bool?) -> Void)?) {
        self.continue = completion
    }
}

// MARK: - Navigation interception
extension NavigationRouter {
    // MARK: Interceptors
    public enum InterceptorQueue: String {
        case car, legal, onboarding, sd, ´default´
    }
    
    /// Interceps navigation to given path with given handler
    /// - Parameters:
    ///   - interceptedPath: Path to intercept navigation for
    ///   - when: When to inercept navigation
    ///   - priority: Interception priority
    ///   - requiresAuthentication: Whether the interception requires authentication or not
    ///   - handler: Interception handler
    public func interceptNavigation(interceptorIdentifier: String = "",
                                    toPath interceptedPath: String,
                                    when: NavigationInterceptorPoint = .before,
                                    withPriority priority: NavigationInterceptionPriority = .low,
                                    recurrence: NavigationInterceptorRecurrence = .always,
                                    requiringAuthentication requiresAuthentication: Bool = false,
                                    queue: InterceptorQueue = .´default´,
                                    file: String = #fileID,
                                    function: String = #function,
                                    line: Int = #line,
                                    handler: ((((Bool?) -> Void)?) -> Void)?) {
        let interceptor = NavigationInterceptor(
            id: !interceptorIdentifier.isEmpty ? interceptorIdentifier : "file: \(file), line: \(line), queue: \(queue.rawValue)",
            path: interceptedPath,
            handler: handler,
            when: when,
            priority: priority,
            recurrence: recurrence,
            requiresAuthentication: requiresAuthentication,
            queue: queue
        )
        
        guard shouldBindInterceptor(interceptor) else {
            return
        }
        
        // Add interceptor
        interceptors.append(interceptor)
    }
    
    /// Removes all registered interceptors for given path
    /// - Parameter path: Path to remove interceptors for
    internal func removeInterceptors(forPath path: String) {
        self.interceptors.removeAll(where: { $0.path == path })
    }
    
    // MARK: Event handlers
    
    /// Router will navigate handler
    /// - Parameter route: Route the router will navigate to
    /// - Parameter parameters: Parameters used for navigation
    /// - Parameter originalPath: Original navigation path
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether to navigate externally or not
    /// - Parameter embedInNavigationView: Whether to embed destination view in a navigation view or not
    /// - Parameter modal: Whether to present the destination view as modal or not
    /// - Parameter shouldPreventDismissal: Whether the presented modal should prevent dismissal or not (if applicable)
    /// - Parameter completion: Completion handler
    /// - Parameter animation: Navigation transition
    internal func routerWillNavigate(toRoute route: NavigationRoute,
                                     withParameters parameters: [String: Any],
                                     originalPath: String,
                                     replace: Bool = false,
                                     embedInNavigationView: Bool = true,
                                     modal: Bool = false,
                                     shouldPreventDismissal: Bool = false,
                                     completion: @escaping (() -> Void),
                                     animation: NavigationTransition? = nil,
                                     completionHandler: @escaping (Bool) -> Void) {
#if DEBUG
        print( "Router is about to navigate to \(originalPath)")
#endif
        
        // Get interceptors for given path
        let interceptors: [NavigationInterceptor] = self.interceptors
            .filter({ $0.path == route.path && $0.when == .before })
        guard !interceptors.isEmpty else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        // Sort interceptors by priority
        let sortedInterceptors: [NavigationInterceptor] = interceptors.sorted(by: { $0 > $1 })
        
#if DEBUG
        print("Running \(sortedInterceptors.count) interceptors...")
#endif
        // Check if interceptors have different queues for running in paralel
        if sortedInterceptors.contains(where: { value in value.queue != .´default´ }) {
                executeWithQueues(
                    sortedInterceptors,
                    when: .before,
                    forRoute: route,
                    withParameters: parameters,
                    originalPath: originalPath,
                    replace: replace,
                    embedInNavigationView: embedInNavigationView,
                    modal: modal,
                    shouldPreventDismissal: shouldPreventDismissal,
                    animation: animation,
                    completionHandler: completionHandler)
        } else {
            // Execute each interceptor by priority and let them handle their own code asynchronously
            self.handleInterceptors(
                sortedInterceptors,
                when: .before,
                forRoute: route,
                withParameters: parameters,
                originalPath: originalPath,
                replace: replace,
                embedInNavigationView: embedInNavigationView,
                modal: modal,
                shouldPreventDismissal: shouldPreventDismissal,
                animation: animation,
                completionHandler: completionHandler)
        }
    }
    
    /// Router did navigate handler
    /// - Parameter route: Route the router will navigate to
    /// - Parameter parameters: Parameters used for navigation
    /// - Parameter originalPath: Original navigation path
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether to navigate externally or not
    /// - Parameter embedInNavigationView: Whether to embed destination view in a navigation view or not
    /// - Parameter modal: Whether to present the destination view as modal or not
    /// - Parameter shouldPreventDismissal: Whether the presented modal should prevent dismissal or not (if applicable)
    /// - Parameter animation: Transition animation (if any)
    internal func routerDidNavigate(toRoute route: NavigationRoute,
                                    withParameters parameters: [String: Any],
                                    originalPath: String,
                                    replace: Bool = false,
                                    embedInNavigationView: Bool = true,
                                    modal: Bool = false,
                                    shouldPreventDismissal: Bool = false,
                                    animation: NavigationTransition? = nil) {
#if DEBUG
        print("Router did navigate to \(originalPath)")
#endif
        
        // Get interceptors for given path
        let interceptors: [NavigationInterceptor] = self.interceptors
            .filter({ $0.path == route.path && $0.when == .after })
        guard !interceptors.isEmpty else {
            return
        }
        
        // Sort interceptors by priority
        let sortedInterceptors: [NavigationInterceptor] = interceptors.sorted(by: { $0 > $1 })
        
#if DEBUG
        print("Running \(sortedInterceptors.count) interceptors...")
#endif
        
        // Execute each interceptor by priority and let them handle their own code asynchronously
        self.handleInterceptors(
            sortedInterceptors,
            when: .after,
            forRoute: route,
            withParameters: parameters,
            originalPath: originalPath,
            replace: replace,
            embedInNavigationView: embedInNavigationView,
            modal: modal,
            shouldPreventDismissal: shouldPreventDismissal,
            animation: animation,
            completionHandler: { _ in }) // Navigation already done
    }
    
    /// Handles given interceptors
    /// - Parameters:
    ///   - interceptors: Interceptors to be handled
    ///   - route: Route to navigate to
    ///   - parameters: Parameters to use for navigation
    ///   - originalPath: Original navigation path
    ///   - replace: Whether to replace the stack with the destination view or not
    ///   - externally: Whether to navigate externally or not
    ///   - embedInNavigationView: Whether to embed the destination view in a navigation view or not
    ///   - modal: Whether to use a modal presentation style for the destination view or not
    ///   - shouldPreventDismissal: Whether the presented modal (if applicable) should prevent dismissal or not
    ///   - when: Interception point
    ///   - animation: Transition animation (if any)
    private func handleInterceptors(
        _ interceptors: [NavigationInterceptor],
        when: NavigationInterceptorPoint,
        forRoute route: NavigationRoute,
        withParameters parameters: [String: Any],
        originalPath: String,
        replace: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        animation: NavigationTransition? = nil,
        finishQueueIntercaptions: ((Result<Void, Error>) -> Void)? = nil,
        completionHandler: @escaping (Bool) -> Void) {
        
        // Get interceptor to handle
        guard let interceptorToHandle: NavigationInterceptor = interceptors.first else {
            return
        }
        
        // Declare interception completion handler
        // swiftlint:disable:next closure_body_length
        let interceptionCompletionHandler: ((Bool?) -> Void) = { (originalNavigationMustBeCancelled: Bool?) in
            // Check if handled interceptor was the last one (or the only one)
            if interceptors.count == 1 {
                // Ensure original navigation must not be cancelled (if needed)
                if !(originalNavigationMustBeCancelled ?? false) {
                    // Perform original navigation
                    if finishQueueIntercaptions != nil {
                        finishQueueIntercaptions?(.success(()))
                    } else {
                        self.navigate(toRoute: route,
                                      withParameters: parameters,
                                      originalPath: originalPath,
                                      replace: replace,
                                      externally: false,
                                      embedInNavigationView: embedInNavigationView,
                                      modal: modal,
                                      shouldPreventDismissal: shouldPreventDismissal,
                                      ignoreInterceptorsBefore: true,
                                      animation: animation ?? .left,
                                      completionHandler: completionHandler)
                    }
                }
            } else if !(originalNavigationMustBeCancelled ?? false) {
                // Let the next interceptor handle its own code before actually navigating to the original path
                self.handleInterceptors(Array(
                    interceptors.dropFirst()),
                    when: when,
                    forRoute: route,
                    withParameters: parameters,
                    originalPath: originalPath,
                    replace: replace,
                    embedInNavigationView: embedInNavigationView,
                    modal: modal,
                    shouldPreventDismissal: shouldPreventDismissal,
                    animation: animation,
                    finishQueueIntercaptions: finishQueueIntercaptions,
                    completionHandler: completionHandler)
            } else {
                completionHandler(false)
            }
        }
        
        // Check if interceptor requires authentication
        if interceptorToHandle.requiresAuthentication,
            !(self.authenticationHandler?.isAuthenticated() ?? false) {
            if let _ = self.authenticationHandler?.login(completion: {
                self.executeInterceptor(interceptorToHandle, completion: interceptionCompletionHandler)
            }) {
            } else {
                finishQueueIntercaptions?(.failure(NSError(domain: "User is not authorized for this request", code: 401)))
            }
        } else {
            self.executeInterceptor(interceptorToHandle, completion: interceptionCompletionHandler)
        }
    }
    
    /// Executes interceptor
    private func executeInterceptor(_ interceptor: NavigationInterceptor, completion: @escaping ((Bool?) -> Void)) {
        handleInterceptorRecurrence(interceptor)
        
        DispatchQueue.main.async {
            interceptor.handler?(completion)
        }
    }
    
    private func shouldBindInterceptor(_ interceptor: NavigationInterceptor) -> Bool {
        return interceptor.recurrence != .oncePerInstallation ||
            !interceptorHasBeenExecuted(id: interceptor.id)
    }
    
    private func interceptorHasBeenExecuted(id: String) -> Bool {
        if let executedInterceptors = UserDefaults.standard.array(forKey: "executed.interceptors") as? [String] {
            return executedInterceptors.contains { $0 == id }
        }
        
        return false
    }
    
    private func handleInterceptorRecurrence(_ interceptor: NavigationInterceptor) {
        var executedInterceptors = UserDefaults.standard.array(forKey: "executed.interceptors") as? [String] ?? []
        
        if !executedInterceptors.contains(where: { $0 == interceptor.id }) {
            executedInterceptors.append(interceptor.id)
            UserDefaults.standard.setValue(executedInterceptors, forKey: "executed.interceptors")
        }
        
        if interceptor.recurrence != .always,
           let interceptorIndex = interceptors.firstIndex(of: interceptor) {
            interceptors.remove(at: interceptorIndex)
        }
    }
}

//MARK: - Parallel interception
/// - Parameters:
/// 1. Run the all high priority(requiredAuth: false, priority: high, .veryHigh, .mandatory) interceptors in 1 serial like previosly
/// 2. Run the only the first one with requiredAuth: true, for checking authroziation
/// 3. Run other requests in parallel in their queues
private extension NavigationRouter {
    func executeWithQueues(
        _ interceptors: [NavigationInterceptor],
        when: NavigationInterceptorPoint,
        forRoute route: NavigationRoute,
        withParameters parameters: [String: Any],
        originalPath: String,
        replace: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        animation: NavigationTransition? = nil,
        finishQueueIntercaptions: ((Result<Void, Error>) -> Void)? = nil,
        completionHandler: @escaping (Bool) -> Void) {
            
            var sortedInterceptors: [NavigationInterceptor] = interceptors
            
            // Split the intercaptors by priority
            let dictionaryByPriority = Dictionary(grouping: sortedInterceptors, by: { determinatePriority($0) })
            
            if let prioritizedInterceptors = dictionaryByPriority[.high]?.sorted(by: { $0 > $1 }), !prioritizedInterceptors.isEmpty {
                self.handleInterceptors(
                    prioritizedInterceptors,
                    when: .before,
                    forRoute: route,
                    withParameters: parameters,
                    originalPath: originalPath,
                    replace: replace,
                    embedInNavigationView: embedInNavigationView,
                    modal: modal,
                    shouldPreventDismissal: shouldPreventDismissal,
                    animation: animation,
                    finishQueueIntercaptions: { result in
                        sortedInterceptors.removeAll { item in
                            prioritizedInterceptors.contains(item)
                        }
                        
                        checkAuthorization {
                            executeSerialsInParalel()
                        }
                    },
                    completionHandler: completionHandler)
     
            } else {
                checkAuthorization {
                    executeSerialsInParalel()
                }
            }
            
            func executeSerialsInParalel() {
                let dictionary = Dictionary(grouping: sortedInterceptors, by: { $0.queue })

                dictionary.forEach { pair in
                    DispatchQueue(label: pair.key.rawValue).async {
                        self.handleInterceptors(
                            pair.value.sorted(by: { $0 > $1 }),
                            when: .before,
                            forRoute: route,
                            withParameters: parameters,
                            originalPath: originalPath,
                            replace: replace,
                            embedInNavigationView: embedInNavigationView,
                            modal: modal,
                            shouldPreventDismissal: shouldPreventDismissal,
                            animation: animation,
                            finishQueueIntercaptions: { result in

                                DispatchQueue.main.async {

                                    sortedInterceptors.removeAll { interactor in
                                        interactor.queue == pair.value.first?.queue
                                    }
                                    
                                    if sortedInterceptors.isEmpty {
                                        self.navigate(toRoute: route,
                                                      withParameters: parameters,
                                                      originalPath: originalPath,
                                                      replace: replace,
                                                      externally: false,
                                                      embedInNavigationView: embedInNavigationView,
                                                      modal: modal,
                                                      shouldPreventDismissal: shouldPreventDismissal,
                                                      ignoreInterceptorsBefore: true,
                                                      animation: animation ?? .left,
                                                      completionHandler: completionHandler)
                                    }
                                }
                            },
                            completionHandler: completionHandler
                        )
                    }
                }
            }
            
            func checkAuthorization(successHandler: @escaping () -> Void) {
                if let firstInteractorWithAuth = sortedInterceptors.first(where: {  $0.requiresAuthentication }) {
                    self.handleInterceptors(
                        [firstInteractorWithAuth],
                        when: .before,
                        forRoute: route,
                        withParameters: parameters,
                        originalPath: originalPath,
                        replace: replace,
                        embedInNavigationView: embedInNavigationView,
                        modal: modal,
                        shouldPreventDismissal: shouldPreventDismissal,
                        animation: animation,
                        finishQueueIntercaptions: { result in
                            switch result {
                            case .success:
                                sortedInterceptors.removeAll {
                                    $0.id == firstInteractorWithAuth.id
                                }
                                
                                if sortedInterceptors.isEmpty {
                                    self.navigate(toRoute: route,
                                                  withParameters: parameters,
                                                  originalPath: originalPath,
                                                  replace: replace,
                                                  externally: false,
                                                  embedInNavigationView: embedInNavigationView,
                                                  modal: modal,
                                                  shouldPreventDismissal: shouldPreventDismissal,
                                                  ignoreInterceptorsBefore: true,
                                                  animation: animation ?? .left,
                                                  completionHandler: completionHandler)
                                } else {
                                    successHandler()
                                }
                            case .failure:
                                sortedInterceptors.removeAll { $0.requiresAuthentication }
                            }
                        },
                        completionHandler: completionHandler)
                }
            }
        }
    
    enum SerialPriority {
        case high
        case medium
    }
    
    func determinatePriority(_ interceptor: NavigationInterceptor) -> SerialPriority {
        if !interceptor.requiresAuthentication {
            return .high
        }
        
        switch interceptor.priority {
        case .high, .veryHigh, .mandatory:
            return .high
        default:
            return .medium
        }
    }
        
}

