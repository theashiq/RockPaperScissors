//
//  GameViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation

protocol PlayerActionListenerDelegate{
    func playerMadeMove(action turn: Turn, playerId: String)
}

class GameViewModel: ObservableObject, PlayerActionListenerDelegate{
    
    @Published private(set) var player1: Player
    @Published private(set) var player2: Player
    
    @Published private(set) var score1: Int = 0
    @Published private(set) var score2: Int = 0
    @Published private(set) var matchPlayed: Int = 0
    @Published private(set) var winner: Player? = nil
    @Published private(set) var gameOver: Bool = false
    
    var isResultViewHidden: Bool{
        matchPlayed < 0 || !gameOver
    }
    
    func result(for player: Player)-> GameResult?{
        guard gameOver else{
            return nil
        }
        
        if let winnerId = winner?.id{
            return winnerId == player.id ? .win : .lose
        }
        
        return .tie
    }
    
    var playerAreaViewModel1: PlayerAreaViewModel{
        PlayerAreaViewModel(
            playerId: player1.id,
            playerActionListener: self,
            isOpponent: true,
            currentTurn: player1.turn,
            result: result(for: player1)
        )
    }
    
    var playerAreaViewModel2: PlayerAreaViewModel{
        PlayerAreaViewModel(
            playerId: player2.id,
            playerActionListener: self,
            isOpponent: false,
            currentTurn: player2.turn,
            result: result(for: player2)
        )
    }
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func playerMadeMove(action turn: Turn, playerId: String) {
        if player1.id == playerId && player1.turn == nil{
            player1.makeTurn(turn)
        }
        else if player2.id == playerId && player2.turn == nil{
            player2.makeTurn(turn)
        }
        
        decideResult()
    }
    
    //MARK:  PlayerActionListenerDelegate
    private func decideResult(){
        
        if let player1Turn = player1.turn,
           let player2Turn = player2.turn{
            
            if let winnerTurn = player1Turn.winner(against: player2Turn){
                if winnerTurn == player1Turn{
                    score1 += 1
                    self.winner = player1
                }
                else{
                    score2 += 1
                    self.winner = player2
                }
            }
            gameOver = true
            matchPlayed += 1
        }
    }
    //MARK: - User intents
    
    func playAgain(){
        winner = nil
        gameOver = false
        player1.getReady()
        player2.getReady()
    }
    
}
