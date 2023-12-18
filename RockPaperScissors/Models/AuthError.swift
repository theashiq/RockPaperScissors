//
//  AuthError.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import Foundation

enum AuthError: Error, LocalizedError, Equatable{
    
    case alreadyLoggedIn
    case notLoggedIn
    case loginFail
    case logoutFail
    case registrationFail
    case passwordResetFail
    case codeVerificationFail
    
    case inProgress
    case other(String, String)
    
    
    var rawValue: String{
        switch self{
            case .alreadyLoggedIn: return "Already Logged In"
            case .notLoggedIn: return "Not Logged In"
            
            case .loginFail: return "Login Failed"
            case .logoutFail: return "Logout Failed"
            case .registrationFail: return "Registration Failed"
            case .passwordResetFail: return "Password Reset Failed"
            case .codeVerificationFail: return "Code Verification Failed"
            
            case .inProgress: return "Try Later"
            case .other(let title, _): return title
        }
    }
    
    
    var errorDescription: String?{
        switch self{
            case .alreadyLoggedIn: return NSLocalizedString("You are already logged in. Log out first.", comment: "")
            case .notLoggedIn: return NSLocalizedString("You are not logged in. Log in first.", comment: "")
            
            case .loginFail: return NSLocalizedString("Failed to login. Please try again later.", comment: "")
            case .logoutFail: return NSLocalizedString("Failed to log out. Please try again later.", comment: "")
            case .registrationFail: return NSLocalizedString("Failed to complete registration. Please try again later.", comment: "")
            case .passwordResetFail: return NSLocalizedString("Failed to complete password reset process. Make sure that your have provided correct credentials", comment: "")
            case .codeVerificationFail: return "Incorrect Verification Code"
            
            case .inProgress: return NSLocalizedString("Another process is ongoing. Please try again later.", comment: "")
            case .other(_, let message): return NSLocalizedString(message, comment: "")
        }
    }
}
