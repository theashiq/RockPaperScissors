//
//  AnonymousAuthenticationView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/15/23.
//

import SwiftUI

struct AnonymousAuthenticationView: View {
    @ObservedObject var viewModel: AnonymousAuthenticationViewModel
    @EnvironmentObject var progressHandler: CustomProgressHandler
    var body: some View {
        Button{
            withAnimation{
                progressHandler.updateProgressState(true, message: "Logging In")
                viewModel.loginAnonymously {
                    progressHandler.updateProgressState(false)
                }
            }
        } label: {
            Text("Login as Guest")
                .foregroundStyle(Color.accentColor)
        }
    }
}

#Preview {
    AnonymousAuthenticationView(viewModel: AnonymousAuthenticationViewModel(anonymousAuthProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}
