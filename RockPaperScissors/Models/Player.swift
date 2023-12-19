//
//  Player.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation

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

enum PlayerType{ case human, ai }

struct Player{
    
    private(set) var id: String
    private(set) var displayName: String = ""
    private(set) var type: PlayerType = .human
    private(set) var turn: Turn? = nil
    
    init(displayName: String, type: PlayerType = .human, turn: Turn? = nil) {
        self.id = UUID().uuidString
        self.displayName = displayName
        self.type = type
        self.turn = turn
    }
    
    mutating func makeTurn(_ turn: Turn){
        self.turn = turn
    }
    mutating func getReady(){
        self.turn = nil
    }
    
    static var dummyHumanPlayer: Player{
        .init(displayName: "Human Player")
    }
    static var dummyAIPlayer: Player{
        .init(displayName: "AI Player", type: .ai)
    }
}
extension Player: Equatable {
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}
