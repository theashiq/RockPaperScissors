//
//  GameSelectionViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation

class GameSelectionViewModel: AlerterViewModel{
    
    private(set) var player1: Player? = nil
    private(set) var player2: Player? = nil
    
    @Published var allTeamsFound: Bool = false
    
    //MARK: - User intents
    
    func singlePlayer(){
        player1 = .dummyAIPlayer
        player2 = .dummyHumanPlayer
        allTeamsFound = true
    }
    func twoPlayer(){
        player1 = .dummyHumanPlayer
        player2 = .dummyHumanPlayer
        allTeamsFound = true
    }
    
    func multiplayer(onComplete: (() -> Void)? = nil){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.alert = .alert("No Player Found", "No one is around. Such emptiness.... Play in single player mode instead.")
            onComplete?()
        }
    }
}
