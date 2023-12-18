//
//  AuthUser.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/15/23.
//

import Foundation

struct AuthUser: Identifiable, Codable{
    var id: String
    var displayName: String = ""
    
    static var defaultDisplayName = "Player"
}
