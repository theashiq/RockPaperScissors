//
//  GameView.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var stayInGame: Bool
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 0){
                PlayerAreaView(viewModel: viewModel.playerAreaViewModel1)
                scoreAndStuff
                PlayerAreaView(viewModel: viewModel.playerAreaViewModel2)
            }
            
            gameResultView
                .transition(AnyTransition.scale.animation(.easeInOut))
                .isHidden(viewModel.isResultViewHidden, remove: true)
        }
    }
    
    private var scoreAndStuff: some View{
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    HStack{
                        HStack {
                            Spacer()
                            Text(viewModel.player1.displayName)
                            Text("\(viewModel.score1)").font(.title).bold()
                        }
                        .frame(width: geometry.size.width / 2 - 5)
                        
                        Text(":")
                            .frame(width: 10)
                        
                        HStack {
                            Text("\(viewModel.score2)").font(.title).bold()
                            Text(viewModel.player2.displayName)
                            Spacer()
                        }
                        .frame(width: geometry.size.width / 2 - 5)
                    }
                    
                    
                }
            }
            .position(x:geometry.frame(in:.local).midX,y:geometry.frame(in:.local).midY)
        }
        .frame(maxHeight: 80)
    }
    
    @ViewBuilder
    private var gameResultView: some View{
        VStack{
            Color(.systemBackground).opacity(0.1)
            Color.teal.opacity(0.8)
                .padding(.horizontal, 50)
                .padding(.vertical, 100)
            
            Button("Play Again"){
                withAnimation {
                    viewModel.playAgain()
                }
            }
            .buttonStyle(.borderless)
            
            Button("Give Up"){
                withAnimation {
                    stayInGame = false
                }
            }
            .buttonStyle(.borderless)
        }
        .frame(height: 200)
    }
}

#Preview {
    GameView(viewModel: GameViewModel(player1: .dummyHumanPlayer, player2: .dummyHumanPlayer), stayInGame: .constant(true))
}

enum GameResult: String{
    case win = "Win"
    case lose = "Lose"
    case tie = "Tie"
}
class PlayerAreaViewModel: ObservableObject{
    
    private var playerId: String
    private var playerActionListener: PlayerActionListenerDelegate?
    
    @Published private(set) var isOpponent: Bool
    @Published private(set) var currentTurn: Turn? = nil
    @Published private(set) var result: GameResult? = nil
    @Published private(set) var isInputsDisabled: Bool = false
    
    init(playerId: String, 
         playerActionListener: PlayerActionListenerDelegate,
         isOpponent: Bool = false,
         currentTurn: Turn? = nil,
         result: GameResult? = nil
    ){
        self.playerId = playerId
        self.playerActionListener = playerActionListener
        self.isOpponent = isOpponent
        self.currentTurn = currentTurn
        self.result = result
        self.isInputsDisabled = currentTurn != nil || result != nil
    }
    
    //MARK: - User intents
    
    func makeTurn(_ turn: Turn){
        isInputsDisabled = true
        playerActionListener?.playerMadeMove(action: turn, playerId: playerId)
    }
}

struct PlayerAreaView: View {
    @ObservedObject var viewModel: PlayerAreaViewModel
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(bgColor)
            Rectangle()
                .foregroundStyle(Color(.systemBackground).opacity(0.75))
                
            HStack(spacing: 50){
                
                Button{
                    withAnimation {
                        viewModel.makeTurn(.rock)
                    }
                } label: {
                    LogoView.rockView
                        .scaleEffect(
                            CGSize(width: viewModel.currentTurn == .rock ? 2.0 : 1.0,
                                   height: viewModel.currentTurn == .rock ? 2.0 : 1.0)
                        )
                }
                
                Button{
                    withAnimation {
                        viewModel.makeTurn(.paper)
                    }
                } label: {
                    LogoView.paperView
                        .scaleEffect(
                            CGSize(width: viewModel.currentTurn == .paper ? 2.0 : 1.0,
                                   height: viewModel.currentTurn == .paper ? 2.0 : 1.0)
                        )
                }
                
                Button{
                    withAnimation {
                        viewModel.makeTurn(.scissors)
                    }
                } label: {
                    
                    LogoView.scissorsView
                        .scaleEffect(
                            CGSize(width: viewModel.currentTurn == .scissors ? 2.0 : 1.0,
                                   height: viewModel.currentTurn == .scissors ? 2.0 : 1.0)
                        )
                }
            }
            .disabled(viewModel.isInputsDisabled)
            .isHidden(viewModel.result != nil)
            
            if viewModel.result != nil{
                Text("Match \(viewModel.result!.rawValue)")
            }
        }
    }
    
    var bgColor: Color{
        viewModel.isOpponent ? .orange : .green
    }
}
