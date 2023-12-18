//
//  CustomSecureField.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/15/23.
//


import SwiftUI


struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    @State private var isPasswordVisible = false
    
    var body: some View{
        
        ZStack(alignment: .trailing){
            CustomTextField(
                text: $text,
                placeholder: placeholder,
                symbolName: "exclamationmark.lock.fill",
                secure: !isPasswordVisible
            )
            
            Button{
                isPasswordVisible.toggle()
            } label:{
                
                Image(systemName: isPasswordVisible ? "eye.slash.fill" :  "eye.fill")
                    .imageScale(.medium)
                    .padding(.trailing)
                    .frame(maxHeight: 50)
                    .frame(width: 40)
            }
        }
    }
}

#Preview {
    CustomSecureField(text: .constant("abcd1234"), placeholder: "Password")
}
