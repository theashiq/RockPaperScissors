//
//  GameSelectionView.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/13/23.
//

import SwiftUI

struct GameSelectionView: View {
    @StateObject var viewModel: GameSelectionViewModel = GameSelectionViewModel()
    @EnvironmentObject var authTracker: AuthTracker
    @EnvironmentObject var progressHandler: CustomProgressHandler
    
    var body: some View {
        
        ZStack{
            VStack {
                Text("Hello, \(authTracker.displayName)!")
                    .isHidden(!authTracker.isAuthenticated, remove: true)
                    .padding(.vertical)
                Spacer()
                
                Button{
                    Task{
                        progressHandler.updateProgressState(true, message: "Searching Player")
                        await viewModel.multiplayer{
                            progressHandler.updateProgressState(false)
                        }
                    }
                } label: {
                    Text("Multiplayer")
                        .frame(width: 150)
                }
                .buttonStyle(.borderedProminent)
                .isHidden(!authTracker.isAuthenticated, remove: true)
                
                Button{
                    withAnimation {
                        viewModel.singlePlayer()
                    }
                } label: {
                    Text("Single Player")
                        .frame(width: 150)
                }
                .buttonStyle(.borderedProminent)
                
                Text("Log in to play online")
                    .isHidden(authTracker.isAuthenticated, remove: true)
                    .padding(.vertical)
                
                Spacer()
            }
            
            if viewModel.proceedToGameView{
                gameView
            }
        }
        .alert(viewModel.alert.title,
                isPresented: $viewModel.isAlertPresented,
                actions: { Button("OK", action: viewModel.dismissAlert) },
                message: { Text(viewModel.alert.message) }
         )
        .onAppear{
            viewModel.authTracker = authTracker
        }
    }
    
    private var gameView: some View{
        GameView(viewModel: GameViewModel(player: viewModel.player!, opponent: viewModel.opponent!), stayInGame: $viewModel.proceedToGameView)
    }
}

#Preview {
    GameSelectionView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}
