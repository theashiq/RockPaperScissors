//
//  EmailAuthenticationView.swift
//  RockPaperScissorsFight
//
//  Created by mac 2019 on 12/11/23.
//

import SwiftUI

struct EmailAuthenticationView: View {
    @ObservedObject var viewModel: EmailAuthenticationViewModel
    @EnvironmentObject var progressHandler: CustomProgressHandler
    
    var body: some View {
        VStack{
            emailPassAuth
        }
        .disabled(viewModel.emailAuthProvider.inProgress)
        .alert(viewModel.alert.title, isPresented: $viewModel.isAlertPresented)
        {
            Button("OK", role: .cancel) {
                viewModel.alert = .none
            }
        } message: {
            Text(viewModel.alert.message)
        }
    }
    
    
    @ViewBuilder
    private var emailPassAuth: some View{
        
        // MARK: Input Fields
        VStack{
            Text(viewModel.emailAuthState.instruction)
            
            CustomTextField(text: $viewModel.displayName, placeholder: "Display Name", symbolName: "person.fill")
                .padding(.bottom, 5)
                .isHidden(viewModel.displayNameFieldHidden, remove: true)
            
            CustomTextField(text: $viewModel.email, placeholder: "Email", symbolName: "envelope.fill")
                .keyboardType(.emailAddress)
                .padding(.bottom, 5)
                .isHidden( viewModel.emailFieldHidden, remove: true)
                
            
            CustomSecureField(text: $viewModel.password, placeholder: "Password")
                .padding(.bottom, 5)
                .isHidden( viewModel.passwordFieldHidden, remove: true )
        }
        
        // MARK: Submit Button
        VStack{
            Button{
                withAnimation{
                    progressHandler.updateProgressState(true, message: "Logging In")
                    viewModel.submitEmailCredentials {
                        progressHandler.updateProgressState(false)
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text(viewModel.emailAuthState.action.uppercased())
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
        
        // MARK: State Change Buttons
        VStack{
            ForEach(viewModel.emailAuthState.nextStates){ state in
                
                HStack{
                    Text(state.question)
                    Button{
                        withAnimation{
                            viewModel.changeState(nextState: state)
                        }
                    } label: {
                        Text(state.secondaryAction)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding(.top)
        .foregroundStyle(.gray)
    }
    
}

#Preview {
    EmailAuthenticationView(viewModel: EmailAuthenticationViewModel(emailAuthProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}
