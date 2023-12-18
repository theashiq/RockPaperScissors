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
            ZStack{
                Image(systemName: "lock")
                    .scaleEffect(CGSize(width: 3.0, height: 3.0))
                    .foregroundStyle(
                        .linearGradient(colors: [.blue, .orange], startPoint: .top, endPoint: .bottomTrailing)
                    )
                
                Image(systemName: "flame.fill")
                    .foregroundStyle(
                        .linearGradient(colors: [.red, Color(.systemFill)], startPoint: .top, endPoint: .bottomTrailing)
                    )
                    .offset(y: 10)
                
            }
            .scaledToFill()
            .frame(width: 100, height: 100)
            .scaleEffect(CGSize(width: 2.0, height: 2.0))
            
            Text("Authentication Flow")
                .multilineTextAlignment(.center)
                .offset(y: 80)
                .foregroundStyle(
                    .linearGradient(colors: [.green, .brown, .orange], startPoint: .bottomLeading, endPoint: .topTrailing)
                )
                .frame(width: 120)
        }
        .offset(y: -25)
        .frame(width: 150, height: 150)
    }
}


#Preview {
    LogoView()
}
