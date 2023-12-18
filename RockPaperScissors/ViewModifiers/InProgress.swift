//
//  CustomProgressView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import SwiftUI

struct InProgress: ViewModifier {
    var isShowing: Bool
    var progressText: String = ""
    
    func body(content: Content) -> some View {
        ZStack{
            content
            Color.accentColor.opacity(0.5)
                .overlay(
                    VStack{
                        ProgressView()
                        Text(progressText)
                    }
                )
                .ignoresSafeArea()
                .isHidden(!isShowing, remove: true)
        }
    }
}

extension View{
    func inProgress(_ inProgress: Bool, progressText: String = "") -> some View{
        modifier(InProgress(isShowing: inProgress, progressText: progressText))
    }
}
