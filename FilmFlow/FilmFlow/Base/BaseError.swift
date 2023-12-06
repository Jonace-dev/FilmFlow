//
//  BaseError.swift
//  CineFlow
//
//  Created by Jonathan Onrubia Solis on 1/12/23.
//

import Foundation

enum ErrorType {
    
    case toast(String)
    case fullScreen(String)
    case popup(BaseError)
    case form(String)
    case popupDismiss((BaseError, () -> Void))
    
}

enum BaseError: Error {
    case generic
    case noInternetConnection
    case tokenExpired
    case credentials
    case otpInvalid
    case otpValid
    case passwordExpired
    case API(APIError)

    func description() -> String {
        
        var description: String = ""
        
        switch self {
        case .generic: description = "error_generic"
        case .noInternetConnection: description = "error_no_internet_connection"
        case .credentials: description = "error_credential"
        case .API(let apiError):
            description = getAPIDescription(apiError: apiError)
        case .tokenExpired:
            description = "dialog_expired_subtitle"
        case .otpInvalid:
            description = "sms_error_dialog_title"
        case .otpValid:
            description = "sms_error_dialog_title"
        case .passwordExpired:
            description = "login_password_expired"
        }
        
        return description

    }
    
    private func getAPIDescription(apiError: APIError) -> String {
        return apiError.localizedMessage ?? "error_generic"
    }
    
//    func popUpType() -> PopupType {
//
//        switch self {
//        case .generic: return PopupType.genericError
//        case .noInternetConnection: return PopupType.genericError
//        case .tokenExpired: return  PopupType.tokenExpired
//        case .otpValid: return PopupType.otpValid
//        case .otpInvalid: return PopupType.otpInvalid
//        case .passwordExpired: return PopupType.passwordExpired
//        default: return PopupType.apiError
//        }
//    }
}

