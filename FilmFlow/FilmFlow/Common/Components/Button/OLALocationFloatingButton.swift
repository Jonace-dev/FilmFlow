////
//// ©2022 SEAT, S.A. All rights reserved.
////
//// This is file is part of a propietary app or framework.
//// Unauthorized reproduction, copying or modification of this file is strictly prohibited.
////
//// This code is proprietary and confidential.
////
//// All the 3rd-party libraries included in the project are regulated by their own licenses.
////
//
//import SwiftUI
//import CoreLocation
//
//import MySEATUITheme
//
//public struct OLALocationFloatingButton: View {
//    // MARK: - Typealiases
//    
//    public typealias OLALocationFloatingButtonAction = (_ userCoordinate: CLLocationCoordinate2D) -> Void
//    
//    // MARK: - Constants
//    
//    private let X_OFFSET: CGFloat = -1.5
//    
//    private let Y_OFFSET: CGFloat = 2.5
//    
//    // MARK: - Properties
//    
//    @ObservedObject private var coordinator: Coordinator = Coordinator()
//    
//    private let action: OLALocationFloatingButtonAction
//    
//    private let shouldShowBlue: Bool
//    
//    // MARK: - Initializer
//    
//    public init(action: @escaping OLALocationFloatingButtonAction, shouldShowBlue: Bool = true) {
//        self.action = action
//        self.shouldShowBlue = shouldShowBlue
//    }
//    
//    // MARK: - View builder
//    
//    public var body: some View {
//        OLAFloatingButton(iconName: iconName, iconColor: iconColor, xOffset: X_OFFSET, yOffset: Y_OFFSET) {
//            if let userCoordinate = coordinator.locationManager.location?.coordinate {
//                action(userCoordinate)
//            }
//        }
//    }
//    
//    // MARK: - Helpers
//    
//    private var showLocationButton: Bool {
//        switch coordinator.locationManager.authorizationStatus {
//        case .authorizedAlways, .authorizedWhenInUse:
//            return true
//            
//        default:
//            return false
//        }
//    }
//    
//    private var iconName: OLAIconName {
//        return (showLocationButton && shouldShowBlue) ? .locationFilled : .location
//    }
//    
//    private var iconColor: Color {
//        return (showLocationButton && shouldShowBlue) ? .olaPrimaryBlueMap : .olaSecondaryNeutral080
//    }
//    
//    // MARK: - Coordinator
//    
//    private class Coordinator: NSObject, ObservableObject, CLLocationManagerDelegate {
//        // MARK: - Properties
//        
//        internal let locationManager: CLLocationManager
//        
//        @Published private var locationAuthorizationStatus: CLAuthorizationStatus
//        
//        // MARK: Initializer
//        
//        internal override init() {
//            let locationManager = CLLocationManager()
//            
//            self.locationManager = locationManager
//            self.locationAuthorizationStatus = locationManager.authorizationStatus
//            
//            super.init()
//            
//            self.locationManager.delegate = self
//        }
//        
//        // MARK: - CLLocationManagerDelegate
//        
//        internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//            locationAuthorizationStatus = manager.authorizationStatus
//        }
//    }
//}
