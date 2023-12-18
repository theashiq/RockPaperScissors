//
//  AnonymousAuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/15/23.
//

import Foundation

class AnonymousAuthenticationViewModel: AlerterViewModel{
    
    private(set) var anonymousAuthProvider: any AnonymousAuthProvider
    
    init(anonymousAuthProvider: AnonymousAuthProvider) {
        self.anonymousAuthProvider = anonymousAuthProvider
    }
    
    // MARK: - User Intents
    func loginAnonymously(onProgressComplete: @escaping ()-> Void){
        guard !anonymousAuthProvider.inProgress else {
            self.alert = .authErrorAlert(from: .inProgress)
            onProgressComplete()
            return
        }
        
        anonymousAuthProvider.loginAnonymously {[weak self] authError in
            DispatchQueue.main.async{
                if let authError{
                    self?.alert = .authErrorAlert(from: authError)
                }
                onProgressComplete()
            }
        }
    }
}
