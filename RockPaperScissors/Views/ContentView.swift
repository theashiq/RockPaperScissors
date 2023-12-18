//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authTracker: AuthTracker
    @State var showAuthView: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    GameSelectionView()
                    
                    Button("Logout") {
                        withAnimation {
                            authTracker.authProvider.logout{ _ in
                                showAuthView = false
                            }
                        }
                    }
                    .isHidden(!authTracker.isAuthenticated, remove: true)
                }
                            
                authView
                    .isHidden(!showAuthView, remove: true)
                    .transition(AnyTransition.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
            }
            .toolbar{
                if !authTracker.isAuthenticated{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Log in"){
                            withAnimation {
                                showAuthView.toggle()
                            }
                        }
                    }
                }
            }
            .onChange(of: authTracker.isAuthenticated){ value in
                if value{
                    showAuthView = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Rock Paper Scissors")
        }
    }
    
    private var authView: some View{
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            AuthenticationView(viewModel: AuthenticationViewModel(authProvider: authTracker.authProvider))
            
            HStack{
                VStack{
                    Button{
                        withAnimation {
                            showAuthView = false
                        }
                    } label:{
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.red)
                            .scaleEffect(CGSize(width: 2, height: 2), anchor: UnitPoint(x: -0.2, y: -0.1))
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}
