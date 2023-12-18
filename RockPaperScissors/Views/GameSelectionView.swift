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
                    withAnimation {
                        progressHandler.updateProgressState(true, message: "Searching Player")
                        viewModel.multiplayer{
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
            
            if viewModel.isOpponentFound{
                GameView(viewModel: GameViewModel(opponent: viewModel.opponent!))
            }
        }
        .alert(viewModel.alert.title,
                isPresented: $viewModel.isAlertPresented,
                actions: { Button("OK", action: viewModel.dismissAlert) },
                message: { Text(viewModel.alert.message) }
         )
    }
}

#Preview {
    GameSelectionView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}

class GameSelectionViewModel: AlerterViewModel{
    
    @Published private(set) var opponent: Player? = nil
    
    var isOpponentFound: Bool{
        opponent != nil
    }
    
    //MARK: - User intents
    
    func singlePlayer(){
        opponent = .computer
    }
    func multiplayer(onComplete: (() -> Void)? = nil){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.alert = .alert("No Player Found", "No one is around. Such emptiness.... Play in single player mode instead.")
            onComplete?()
        }
    }
}
