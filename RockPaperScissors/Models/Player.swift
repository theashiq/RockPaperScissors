//
//  Player.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation
import FirebaseFirestore

enum Turn: Int, CaseIterable{
    case rock = 1, paper, scissors
    
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
}



protocol Player: Identifiable {
    var id: String {get}
    var displayName: String {get}
    var isReady: Bool {get}
    var turn: Turn? {get}
    var actionListener: PlayerActionListenerDelegate? {get set}
    
    func proceedToMakeMove()
    func prepare()
}

class AiPlayer: Player{
    private(set) var id: String
    private(set) var displayName: String
    private(set) var turn: Turn?
    private(set) var isReady: Bool = false{
        didSet{
            if isReady, let actionListener{
                turn = .random
                actionListener.playerMadeMove(action: turn!, playerId: id)
                isReady = false
            }
        }
    }
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
        isReady = true
    }
    
    func prepare(){
        turn = nil
    }
}

class SinglePlayer: Player, PlayerActionListenerDelegate{
    
    private(set) var id: String
    private(set) var displayName: String
    private(set) var turn: Turn?
    private(set) var isReady: Bool = false
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
        isReady = true
    }
    
    func prepare(){
        turn = nil
    }
    
    func playerMadeMove(action turn: Turn, playerId: String) {
        if isReady, let actionListener{
            self.turn = turn
            actionListener.playerMadeMove(action: turn, playerId: id)
            isReady = false
        }
    }
}


class FirebasePlayer: Player{
    private(set) var id: String
    private(set) var displayName: String
    private(set) var turn: Turn?
    private(set) var isReady: Bool = false
    var actionListener: PlayerActionListenerDelegate?
    var gameDocument: DocumentReference
    
    init(id: String, displayName: String, gameDocument: DocumentReference) {
        self.id = id
        self.displayName = displayName
        self.gameDocument = gameDocument
    }
    
    func proceedToMakeMove() {
        
    }
    
    func prepare() {
        
    }
    
    
}


class FirebaseOpponentPlayer: Player{
    private(set) var id: String
    private(set) var displayName: String
    private(set) var turn: Turn?
    private(set) var isReady: Bool = false
    var actionListener: PlayerActionListenerDelegate?
    var gameDocument: DocumentReference
    
    init(id: String, displayName: String, gameDocument: DocumentReference) {
        self.id = id
        self.displayName = displayName
        self.gameDocument = gameDocument
    }
    
    func proceedToMakeMove() {
        
    }
    
    func prepare() {
        
    }
    
    
}
