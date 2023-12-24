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
    
    @Published private(set) var game: Game
    
    var isResultViewHidden: Bool{
        matchPlayed < 0 || !gameOver
    }
    
    var playerAreaViewModel: PlayerAreaViewModel{
        PlayerAreaViewModel(
            playerId: game.p1Id,
            playerActionListener: player is PlayerActionListenerDelegate ? player as? PlayerActionListenerDelegate : nil,
            isOpponent: true,
            currentTurn: game.p1Turn,
            result: playerResult
        )
    }
    
    var opponentAreaViewModel: PlayerAreaViewModel{
        PlayerAreaViewModel(
            playerId: game.p2Id,
            playerActionListener: opponent is PlayerActionListenerDelegate ? opponent as? PlayerActionListenerDelegate : nil,
            isOpponent: false,
            currentTurn: game.p2Turn,
            result: playerResult?.opposite
        )
    }
    
    init(player: any Player, opponent: any Player) {
        self.player = player
        self.opponent = opponent
        self.game = .from(player: player, opponent: opponent)
        
        self.player.actionListener = self
        self.opponent.actionListener = self
    }
    
    //MARK: PlayerActionListenerDelegate
    
    func playerMadeMove(action turn: Turn, playerId: String) {

        if let playerTurn = player.turn, let opponentTurn =  opponent.turn{
            game.p1Turn = playerTurn
            game.p2Turn = opponentTurn
            
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
    
    func playerReady(playerId: String) {
        if playerId == player.id && !game.p1Ready{
            game.p1Ready = true
        }
        else if playerId == opponent.id && !game.p2Ready{
            game.p2Ready = true
        }
        else{
            return
        }
        
        if game.p1Ready && game.p2Ready{
            allowMove()
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
        game.p1Turn = nil
        game.p2Turn = nil
        player.beReady()
        opponent.beReady()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.allowMove()
        }
    }
    
}
