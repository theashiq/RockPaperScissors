//
//  CustomProgressView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import Foundation

class CustomProgressHandler: ObservableObject{
    @Published var inProgress: Bool = false
    @Published var progressMessage: String = ""
    
    func updateProgressState(_ inProgress: Bool, message: String = ""){
        self.inProgress = inProgress
        self.progressMessage = inProgress ? message : ""
    }
}
