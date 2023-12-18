//
//  RockPaperScissorsApp.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import SwiftUI
import FirebaseCore

@main
struct RockPaperScissorsApp: App {
    @StateObject var authTracker = AuthTracker(authProvider: FirebaseAuthProvider())

       init() {
           // Use Firebase library to configure APIs
           FirebaseApp.configure()
       }
       
       var body: some Scene {
           WindowGroup {
               LoaderView()
                   .environmentObject(authTracker)
           }
       }
}
