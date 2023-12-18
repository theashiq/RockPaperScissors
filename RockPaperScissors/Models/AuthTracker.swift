//
//  AuthTracker.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import Foundation

class AuthTracker: ObservableObject, AuthUserUpdateDelegate{

    @Published private(set) var userId: String? = nil
    @Published private(set) var displayName: String = ""
    @Published private(set) var isAuthenticated: Bool = false
    
    private(set) var authProvider: AuthProvider
    
    init(authProvider: AuthProvider) {
        self.authProvider = authProvider
        self.authProvider.authUserUpdateDelegate = self
    }
    
    // MARK: AuthUserUpdateDelegate methods
    func authUserDidChange(authUser: AuthUser?) {
        DispatchQueue.main.async{
            self.userId = authUser?.id
            self.displayName = authUser?.displayName ?? AuthUser.defaultDisplayName
            self.isAuthenticated = authUser != nil
        }
    }
}

protocol AuthUserUpdateDelegate{
    func authUserDidChange(authUser: AuthUser?)
}
