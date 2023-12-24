//
//  PlayerAreaViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/20/23.
//

import Foundation

class PlayerAreaViewModel: ObservableObject{
    
    private var playerId: String
    private var playerActionListener: PlayerActionListenerDelegate?
    
    @Published private(set) var isOpponent: Bool
    @Published private(set) var currentTurn: Turn? = nil
    @Published private(set) var result: GameResult? = nil
    @Published private(set) var isInputsDisabled: Bool = false
    
    init(playerId: String,
         playerActionListener: PlayerActionListenerDelegate?,
         isOpponent: Bool = false,
         currentTurn: Turn? = nil,
         result: GameResult? = nil
    ){
        self.playerId = playerId
        self.playerActionListener = playerActionListener
        self.isOpponent = isOpponent
        self.currentTurn = currentTurn
        self.result = result
        self.isInputsDisabled = currentTurn != nil || 
                                result != nil ||
                                playerActionListener == nil
    }
    
    //MARK: - User intents
    
    func makeTurn(_ turn: Turn){
        isInputsDisabled = true
        playerActionListener?.playerMadeMove(action: turn, playerId: playerId)
    }
    
    func playerReady(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.playerActionListener?.playerReady(playerId: self.playerId)
        }
    }
}
