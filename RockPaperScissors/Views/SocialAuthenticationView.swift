//
//  SocialAuthenticationView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import SwiftUI

struct SocialAuthenticationView: View {
    
    @ObservedObject var viewModel: SocialAuthenticationViewModel
    @EnvironmentObject var progressHandler: CustomProgressHandler
    
    var body: some View {
        
        ZStack{
            VStack{
                socialLoginButtons
                    .alert(viewModel.alert.title,
                           isPresented: $viewModel.isAlertPresented,
                           actions: { Button("OK", action: viewModel.dismissAlert) },
                           message: { Text(viewModel.alert.message) }
                    )
                
            }
        }
    }
    
    private var socialLoginButtons: some View{
        HStack{
            ForEach(viewModel.socialAuthOptions, id: \.self){ socialOption in
                
                Button{
                    withAnimation{
                        progressHandler.updateProgressState(true, message: "Logging In")
                        viewModel.socialLogin(option: socialOption ){
                            progressHandler.updateProgressState(false)
                        }
                    }
                } label: {
                    
                    Circle()
                        .frame(width: 65, height: 65)
                        .foregroundStyle(colorForSocialButton(socialOption: socialOption))
                        .overlay{
                            Text(socialOption.name)
                                .bold()
                                .accentColor(.white)
                        }
                    
                }
            }
        }
    }
    
    private func colorForSocialButton(socialOption: SocialAuthOption) -> Color{
        switch socialOption {
        case .apple:
                return Color.gray
        case .google:
                return Color.blue
        }
    }
}

#Preview {
    SocialAuthenticationView(viewModel: SocialAuthenticationViewModel(socialAuthProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}
