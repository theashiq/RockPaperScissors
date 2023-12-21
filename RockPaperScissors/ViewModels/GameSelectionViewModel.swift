//
//  GameSelectionViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation

class GameSelectionViewModel: AlerterViewModel{
    
    private(set) var player1: (any Player)? = nil
    private(set) var player2: (any Player)? = nil{
        didSet{
            proceedToGameView = true
        }
    }
    
    @Published var proceedToGameView: Bool = false
    
    //MARK: - User intents
    
    func singlePlayer(authUser: AuthUser? = nil){
        if let authUser{
            player1 = SinglePlayer(id: authUser.id, displayName: authUser.displayName)
        }
        else{
            player1 = SinglePlayer(displayName: "You")
        }
        player2 = AiPlayer(displayName: "AI Player")
    }
    
    func multiplayer(authUser: AuthUser?, onComplete: (() -> Void)? = nil){
        guard let authUser else{
            alert = .alert("Log In First", "You are not logged in. Log in to play online")
            onComplete?()
            return
        }
        
//        player1 = Player(id: authUser.id, displayName: authUser.displayName)
//        
//        player2 = Player(id: authUser.id, displayName: authUser.displayName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.alert = .alert("No Player Found", "No one is around. Such emptiness.... Play in single player mode instead.")
            onComplete?()
        }
    }
}
