//
//  Player.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation
import FirebaseFirestore

enum Turn: String, CaseIterable, Codable{
    case rock = "rock", paper = "paper", scissors = "scissors"
    
    static var random: Turn{
        Turn.allCases.randomElement()!
    }
    
    func winner(against: Turn) -> Turn?{
        
        guard self != against else{
            return nil
        }
        
        switch self {
        case .rock:
            return against == .scissors ? .rock : .scissors
        case .paper:
            return against == .rock ? .paper : .rock
        case .scissors:
            return against == .paper ? .scissors : .paper
        }
    }
}

protocol PlayerActionListenerDelegate{
    func playerMadeMove(action turn: Turn, playerId: String)
    func playerReady(playerId: String)
}


struct Game: Codable{
    var p1Id: String = ""
    var p2Id: String = ""
    
    var p1DisplayName: String = ""
    var p2DisplayName: String = ""
    
    var p1Turn: Turn? = nil
    var p2Turn: Turn? = nil
    
    var p1Ready: Bool = false
    var p2Ready: Bool = false
    
    var p1MoveAllowed: Bool = false
    var p2MoveAllowed: Bool = false
    
    var p1Left: Bool = false
    var p2Left: Bool = false
    
    static func from(player: any Player, opponent: any Player) -> Game{
        return Game(
            p1Id: player.id,
            p2Id: opponent.id,
            
            p1DisplayName: player.displayName,
            p2DisplayName: opponent.displayName,
            
            p1Turn: player.turn,
            p2Turn: opponent.turn,
            
            p1Ready: player.ready,
            p2Ready: opponent.ready,
            
            p1MoveAllowed: player.allowMove,
            p2MoveAllowed: opponent.allowMove,
            
            p1Left: false,
            p2Left: false
        )
    }
}

protocol Player: Identifiable {
    var id: String {get}
    var displayName: String {get}
    var ready: Bool {get}
    var allowMove: Bool {get}
    var turn: Turn? {get}
    var actionListener: PlayerActionListenerDelegate? {get set}
    
    func proceedToMakeMove()
    func beReady()
}

class AiPlayer: Player{
    private(set) var id: String
    private(set) var displayName: String
    private(set) var turn: Turn?{
        didSet{
            if let turn, allowMove{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    self.actionListener?.playerMadeMove(action: turn, playerId: self.id)
                }
                
                ready = false
                allowMove = false
            }
        }
    }
    
    private(set) var ready: Bool = false{
        didSet{
            if ready{
                actionListener?.playerReady(playerId: id)
            }
        }
    }
    var allowMove: Bool = false{
        didSet{
            if allowMove{
                turn = .random
            }
        }
    }
    var actionListener: PlayerActionListenerDelegate?
    
    init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
        beReady()
    }
    init(displayName: String) {
        self.id = UUID().uuidString
        self.displayName = displayName
        beReady()
    }
    
    func proceedToMakeMove(){
        allowMove = true
    }
    
    func beReady(){
        turn = nil
        ready = true
    }
}

class SinglePlayer: Player, PlayerActionListenerDelegate{
    
    private(set) var id: String
    private(set) var displayName: String
    
    private(set) var turn: Turn?{
        didSet{
            if let turn, allowMove{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    self.actionListener?.playerMadeMove(action: turn, playerId: self.id)
                }
                
                ready = false
                allowMove = false
            }
        }
    }
    
    private(set) var ready: Bool = false{
        didSet{
            if ready{
                actionListener?.playerReady(playerId: id)
            }
        }
    }
    var allowMove: Bool = false
    
    var actionListener: PlayerActionListenerDelegate?
    
    init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
    init(displayName: String) {
        self.id = UUID().uuidString
        self.displayName = displayName
    }
    
    func proceedToMakeMove(){
        allowMove = true
    }
    
    func beReady(){
        turn = nil
        ready = true
    }
    
    func playerMadeMove(action turn: Turn, playerId: String) {
        if allowMove{
            self.turn = turn
        }
    }
    
    func playerReady(playerId: String) {
        beReady()
    }
}


class FirebasePlayer: Player, PlayerActionListenerDelegate{
    
    private(set) var id: String
    private(set) var displayName: String
    private(set) var isOpponent: Bool
    
    private(set) var turn: Turn?{
        didSet{
            if let turn, allowMove{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    self.actionListener?.playerMadeMove(action: turn, playerId: self.id)
                }
                
                ready = false
                allowMove = false
            }
        }
    }
    
    private(set) var ready: Bool = false{
        didSet{
            if ready{
                actionListener?.playerReady(playerId: id)
            }
        }
    }
    var allowMove: Bool = false
    
    var actionListener: PlayerActionListenerDelegate?
    
    var gameDocument: DocumentReference
    var game: Game! = nil{
        didSet{
            if isOpponent{
                ready = game.p2Ready
                
                if ready && game.p2MoveAllowed{
                    allowMove = true
                }
                if allowMove{
                    turn = game.p2Turn
                }
            }
            else{
                ready = game.p1Ready
                
                if ready && game.p1MoveAllowed{
                    allowMove = true
                }
                if allowMove{
                    turn = game.p1Turn
                }
            }
        }
    }
    
    init(id: String, displayName: String, gameDocument: DocumentReference, isOpponent: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.gameDocument = gameDocument
        self.isOpponent = isOpponent
        self.gameDocument.addSnapshotListener(listenToGameDocument)
    }
    
    func listenToGameDocument(snap: DocumentSnapshot?, error: Error?){
        guard let snap else{
            leaveGame(273)
            return
        }
        if error != nil{
            leaveGame(277)
        }
        do{
            game = try snap.data(as: Game.self)
        }
        catch{
            leaveGame(283)
        }
    }
    
    private func leaveGame(_ fromLine: Int){
        // TODO: set leave game flag manually
        print("leave game from line \(fromLine)")
//        if isOpponent{
//            gameDocument.updateData(["p2Left" : true])
//        }
//        else{
//            gameDocument.updateData(["p1Left" : true])
//        }
    }
    
    func proceedToMakeMove(){
        
        if isOpponent{
            game.p2MoveAllowed = true
        }
        else{
            game.p1MoveAllowed = true
        }
        
        do{
            try gameDocument.setData(from: game, merge: true)
        }
        catch{
            leaveGame(311)
        }
    }
    
    func beReady(){
        if isOpponent{
            game.p2Ready = true
            game.p2Turn = nil
        }
        else{
            game.p1Ready = true
            game.p1Turn = nil
        }
        do{
            try gameDocument.setData(from: game, merge: true)
        }
        catch{
            leaveGame(328)
        }
    }
    
    func playerMadeMove(action turn: Turn, playerId: String) {
        if allowMove{
            if isOpponent{
                game.p2Turn = turn
            }
            else{
                game.p1Turn = turn
            }
            
            do{
                try gameDocument.setData(from: game, merge: true)
            }
            catch{
                leaveGame(344)
            }
        }
    }
    
    func playerReady(playerId: String) {
        beReady()
    }
}
