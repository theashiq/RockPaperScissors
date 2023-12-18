//
//  AuthProvider.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import Foundation

typealias AuthResponseHandler = (AuthError?) -> Void

// MARK: AuthProvider
protocol AuthProvider {
    var inProgress: Bool { get }
    var authUserUpdateDelegate: AuthUserUpdateDelegate? { get set }
    func retainExistingUser(handler: AuthResponseHandler?)
    func logout(handler: AuthResponseHandler?)
}

// MARK: AnonymousAuthProvider
protocol AnonymousAuthProvider {
    var inProgress: Bool { get }
    func loginAnonymously(handler: AuthResponseHandler?)
}

// MARK: EmailAuthProvider
protocol EmailAuthProvider: AuthProvider{
    var inProgress: Bool { get }
    func emailPassRegister(displayName: String, email: String, password: String, handler: AuthResponseHandler?)
    func emailPassLogin(email: String, password: String, handler: AuthResponseHandler?)
    func resetPassword(email: String, handler: AuthResponseHandler?)
}

// MARK: SocialAuthProvider
enum SocialAuthOption { case google, apple }

extension SocialAuthOption{
    var name: String{
        switch self{
        case .apple: "Apple"
        case .google: "Google"
        }
    }
}
protocol SocialAuthProvider: AuthProvider{
    var inProgress: Bool { get }
    var supportedSocialOptions: Set<SocialAuthOption> {get}
    func socialLogin(option: SocialAuthOption, handler: AuthResponseHandler?)
}

// MARK: PhoneAuthProvider
protocol PhoneAuthProvider: AuthProvider{
    var inProgress: Bool { get }
    func phoneRegister(phone: String, handler: AuthResponseHandler?)
    func verifyPhoneNumber(code: String, handler: AuthResponseHandler?)
}
