//
//  GameViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation

enum GameResult: String{
    case win = "Win"
    case lose = "Lose"
    case tie = "Tie"
    
    var opposite: GameResult{
        switch self {
        case .lose: return .win
        case .win: return .lose
        case .tie: return .tie
        }
    }
}

class GameViewModel: ObservableObject, PlayerActionListenerDelegate{
    
    @Published private(set) var player: any Player
    @Published private(set) var opponent: any Player

    @Published private(set) var playerScore: Int = 0
    @Published private(set) var opponentScore: Int = 0
    
    @Published private(set) var matchPlayed: Int = 0
    @Published private(set) var playerResult: GameResult? = nil
    @Published private(set) var gameOver: Bool = false
    
    var isResultViewHidden: Bool{
        matchPlayed < 0 || !gameOver
    }
    
    var playerAreaViewModel: PlayerAreaViewModel{
        PlayerAreaViewModel(
            playerId: player.id,
            playerActionListener: player is PlayerActionListenerDelegate ? player as? PlayerActionListenerDelegate : nil,
            isOpponent: true,
            currentTurn: player.turn,
            result: playerResult
        )
    }
    
    var opponentAreaViewModel: PlayerAreaViewModel{
        PlayerAreaViewModel(
            playerId: opponent.id,
            playerActionListener: opponent is PlayerActionListenerDelegate ? opponent as? PlayerActionListenerDelegate : nil,
            isOpponent: false,
            currentTurn: opponent.turn,
            result: playerResult?.opposite
        )
    }
    
    init(player: any Player, opponent: any Player) {
        self.player = player
        self.opponent = opponent
        self.player.actionListener = self
        self.opponent.actionListener = self
    }
    
    //MARK:  PlayerActionListenerDelegate
    
    func playerMadeMove(action turn: Turn, playerId: String) {

        if let playerTurn = player.turn, let opponentTurn =  opponent.turn{
            gameOver = true
            if playerTurn == opponentTurn{
                playerResult = .tie
            }
            else{
                if playerTurn.winner(against: opponentTurn) == playerTurn{
                    playerScore += 1
                    playerResult = .win
                }
                else{
                    opponentScore += 1
                    playerResult = .lose
                }
            }
        }
    }
    
    //MARK: - User intents
    
    func allowMove(){
        player.proceedToMakeMove()
        opponent.proceedToMakeMove()
    }
    
    func playAgain(){
        gameOver = false
        playerResult = nil
        player.prepare()
        opponent.prepare()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.allowMove()
        }
    }
    
}
