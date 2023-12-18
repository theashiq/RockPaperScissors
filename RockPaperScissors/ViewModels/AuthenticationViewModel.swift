//
//  AuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import FirebaseAuth


class AuthenticationViewModel: AlerterViewModel{
    
    enum AuthViewSelection{ case none, phone, email }
    
    private(set) var authProvider: any AuthProvider
    
    @Published private(set) var isAnonymousAuthAvailable: Bool = false
    @Published private(set) var isEmailAuthAvailable: Bool = false
    @Published private(set) var isPhoneAuthAvailable: Bool = false
    @Published private(set) var isSocialAuthAvailable: Bool = false
    @Published private(set) var socialAuthOptions: [SocialAuthOption] = []
    
    @Published private(set) var selectedAuthView: AuthViewSelection = .none
    
    init(authProvider: AuthProvider){
        self.authProvider = authProvider
        self.isAnonymousAuthAvailable = authProvider is AnonymousAuthProvider
        self.isEmailAuthAvailable = authProvider is EmailAuthProvider
        self.isPhoneAuthAvailable = authProvider is PhoneAuthProvider
        self.isSocialAuthAvailable = authProvider is SocialAuthProvider
        self.socialAuthOptions = (authProvider as? SocialAuthProvider)?.supportedSocialOptions.filter{ _ in true} ?? []
    }
    
    private func providerSelectionPressed(selectedView: AuthViewSelection){
        if selectedAuthView == selectedView{
            selectedAuthView = .none
        }
        else{
            selectedAuthView = selectedView
        }
    }
    
    // MARK: - User Intents
    
    func selectEmailAuthView(){
        providerSelectionPressed(selectedView: .email)
    }
    func selectPhoneAuthView(){
        providerSelectionPressed(selectedView: .phone)
    }
    func unselectAuthView(){
        providerSelectionPressed(selectedView: .none)
    }
}
