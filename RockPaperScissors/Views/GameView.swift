//
//  GameView.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import SwiftUI

enum TurnState: Int{
    case rock = 1, paper, scissors
}

struct Player: Identifiable{
    var id: String
    var isReady: Bool
    var turn: TurnState? = nil
    
    static var dummy: Player { Player(id: UUID().uuidString, isReady: false) }
    static var computer: Player { Player(id: UUID().uuidString, isReady: false) }
}

class GameViewModel: ObservableObject{
    
    @Published private(set) var player: Player
    @Published private(set) var opponent: Player
    
    init(opponent: Player) {
        self.player = .dummy
        self.opponent = opponent
    }
}

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 0){
                GameArenaView(player: viewModel.opponent)
                    .border(.orange)
                scoreAndStuff
                GameArenaView(player: viewModel.player)
                    .border(.cyan)
            }
        }
    }
    
    private var scoreAndStuff: some View{
        GeometryReader{ proxy in
            HStack{
                HStack {
                    Text("You: ")
                    Text("5").bold()
                }
                .frame(width: proxy.size.width / 2)
                Divider()
                HStack {
                    Text("Opponent: ")
                    Text("2").bold()
                }
                .frame(width: proxy.size.width / 2)
            }
        }
        .frame(maxHeight: 50)
    }
}

#Preview {
    GameView(viewModel: GameViewModel(opponent: .dummy))
}



struct GameArenaView: View {
    @State var player: Player
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(Color(.systemBackground))
            Text(player.id)
        }
    }
}
