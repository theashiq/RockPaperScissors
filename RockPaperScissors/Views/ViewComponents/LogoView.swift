//
//  LogoView.swift
//  RockPaperScissorsFight
//
//  Created by mac 2019 on 12/7/23.
//

import SwiftUI

struct LogoView: View {
    var body: some View{
        ZStack{
            HStack{
                LogoView.rockView
                .frame(width: 70)
                .offset(x: 35, y: -25)
        
                LogoView.paperView
                .frame(width: 70)
                .offset(y: 10)
        
                LogoView.scissorsView
                .frame(width: 70)
                .offset(x: -35, y: 45)
            }
            .frame(width: 150, height: 120)
        }
    }
    
    static var rockView: some View{
        Text("Rock")
        .overlay(alignment: .center){
            Image(systemName: "cloud.fill").rotationEffect(.degrees(-130))
                .offset(y: -20)
        }
        .foregroundStyle(
            .linearGradient(colors: [.red, Color(.systemFill)], startPoint: .top, endPoint: .bottomTrailing)
        )
    }
    
    static var paperView: some View{
        Text("Paper")
        .overlay(alignment: .center){
            Image(systemName: "newspaper.fill")
                .offset(y: -20)
        }
        .foregroundStyle(
            .linearGradient(colors: [.green, Color(.systemFill)], startPoint: .top, endPoint: .bottomTrailing)
        )
    }
    
    static var scissorsView: some View{
        Text("Scissors")
        .overlay(alignment: .center){
            Image(systemName: "scissors")
                .offset(y: -20)
        }
        .foregroundStyle(
            .linearGradient(colors: [.blue, Color(.systemFill)], startPoint: .top, endPoint: .bottomTrailing)
        )
    }
}


#Preview {
    LogoView()
}
