//
//  LoaderView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//


import SwiftUI

struct LoaderView: View{
    
    @EnvironmentObject var authTracker: AuthTracker
    @StateObject var progressHandler: CustomProgressHandler = CustomProgressHandler()
    @State private var isShowingLogo = true
    
    var body: some View{

        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if isShowingLogo{
                loadingView
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            isShowingLogo = false
                        }
                    }
            }
            else{
                ContentView()
                    .inProgress(progressHandler.inProgress, progressText: progressHandler.progressMessage)
                    .environmentObject(progressHandler)
            }
        }
    }
    
    private var loadingView: some View{
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack{
                
                Spacer()
                
                LogoView()
                    .frame(height: 100)
                
                Spacer()
                
    //            VStack{
    //                ProgressView()
    //                Text("Loading")
    //            }
    //            .padding(.bottom, 50)
            }
            
        }
    }
}

#Preview {
    LoaderView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
        .environmentObject(CustomProgressHandler())
}
