//
//  CustomButton.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/17/23.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button{
            withAnimation{
                action()
            }
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
            }
        }
        .background(Color.accentColor)
        .cornerRadius(10)
        .padding(.top)
    }
}

#Preview {
    CustomButton(title: "Custom Button", action: {})
}
