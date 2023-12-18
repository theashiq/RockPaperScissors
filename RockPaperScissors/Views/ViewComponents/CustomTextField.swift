//
//  CustomTextField.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/15/23.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let symbolName: String
    var secure: Bool = false
    
    var body: some View{
        HStack {
            Image(systemName: symbolName)
                .imageScale(.large)
                .foregroundStyle(.gray)
                .padding(.leading)
                .frame(width: 45)
            
            Group{
                if secure{
                    SecureField(placeholder, text: $text)
                }
                else{
                    TextField(placeholder, text: $text)
                }
            }
            .padding(.vertical)
            .autocapitalization(.none)
        }
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .circular)
                .foregroundColor(Color(.secondarySystemFill))
        )
    }
}

#Preview {
    CustomTextField(text: .constant("Custom Text"), placeholder: "Custom Text", symbolName: "rectangle", secure: false)
}
