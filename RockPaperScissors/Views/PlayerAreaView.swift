//
//  PlayerAreaView.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/20/23.
//

import SwiftUI

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
            
            if viewModel.result != nil{
                VStack{
                    Spacer()
                    Text("Match \(viewModel.result!.rawValue)")
                }
                .padding()
            }
        }
        
        .onAppear{
            viewModel.playerReady()
        }
    }
    
    var bgColor: Color{
        viewModel.isOpponent ? .orange : .green
    }
}


#Preview {
    PlayerAreaView(viewModel: PlayerAreaViewModel(playerId: "", playerActionListener: nil))
}
