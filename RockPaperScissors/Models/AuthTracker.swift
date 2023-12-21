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
    @Published private(set) var user: AuthUser? = nil{
        didSet{
            self.userId = user?.id
            self.displayName = user?.displayName ?? AuthUser.defaultDisplayName
            self.isAuthenticated = user != nil
        }
    }
    
    private(set) var authProvider: AuthProvider
    
    init(authProvider: AuthProvider) {
        self.authProvider = authProvider
        self.authProvider.authUserUpdateDelegate = self
    }
    
    // MARK: AuthUserUpdateDelegate methods
    func authUserDidChange(authUser: AuthUser?) {
        DispatchQueue.main.async{
            self.user = authUser
        }
    }
}

protocol AuthUserUpdateDelegate{
    func authUserDidChange(authUser: AuthUser?)
}
