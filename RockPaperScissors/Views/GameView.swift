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
                PlayerAreaView(viewModel: viewModel.opponentAreaViewModel)
                scoreAndStuff
                PlayerAreaView(viewModel: viewModel.playerAreaViewModel)
            }
            
            gameResultView
                .transition(AnyTransition.asymmetric(insertion: .scale.animation(.easeInOut),
                                                     removal: .scale.animation(.easeInOut)))
                .isHidden(viewModel.isResultViewHidden, remove: true)
        }
        .onAppear{
            viewModel.allowMove()
        }
    }
    
    private var scoreAndStuff: some View{
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    HStack{
                        HStack {
                            Spacer()
                            Text(viewModel.player.displayName)
                            Text("\(viewModel.playerScore)").font(.title).bold()
                        }
                        .frame(width: geometry.size.width / 2 - 5)
                        
                        Text(":")
                            .frame(width: 10)
                        
                        HStack {
                            Text("\(viewModel.opponentScore)").font(.title).bold()
                            Text(viewModel.opponent.displayName)
                            Spacer()
                        }
                        .frame(width: geometry.size.width / 2 - 5)
                    }
                }
            }
            .position(x:geometry.frame(in:.local).midX,y:geometry.frame(in:.local).midY)
        }
        .frame(maxHeight: 100)
    }
    
    @ViewBuilder
    private var gameResultView: some View{
        ZStack{
            Color(.systemBackground)
            Color.teal.opacity(0.8)
                .padding(.horizontal, 50)
                .padding(.vertical, 100)
            
            VStack{
                scoreAndStuff
                
                Group{
                    
                    Text("Yey!!! You Won").foregroundStyle(.green)
                        .isHidden(viewModel.playerResult != .win, remove: true)
                    Text("Oh no!!! You Lost").foregroundStyle(.red)
                        .isHidden(viewModel.playerResult != .lose, remove: true)
                    Text("Match Tie")
                        .isHidden(viewModel.playerResult != .tie, remove: true)
                }
                .font(.title.bold())
                .padding(.bottom)
                
                
                Button("Play Again"){
                    withAnimation {
                        viewModel.playAgain()
                    }
                }
                .buttonStyle(.borderless)
                .padding(.bottom)
                
                Button("Return"){
                    withAnimation {
                        stayInGame = false
                    }
                }
                .buttonStyle(.borderless)
            }
            
        }
        .frame(height: 200)
    }
}

#Preview {
    GameView(viewModel: GameViewModel(
        player: AiPlayer(displayName: "AI Player"),
        opponent: AiPlayer(displayName: "AI Opponent")
    ), stayInGame: .constant(true))
}
