//
//  Alert.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import Foundation

enum AlertMe: Equatable, Identifiable{
    
    var id: String{
        switch self{
            case .none: return ""
            default: return UUID().uuidString
        }
    }
        
    case none
    case alert(String, String)
    
    var title: String{
        switch self{
        case .none: return ""
        case .alert(let title, _): return title
        }
    }
    var message: String{
        switch self{
        case .none: return ""
        case .alert(_, let message): return message
        }
    }
    
}

extension AlertMe {
    static func authErrorAlert(from authError: AuthError) -> AlertMe{
        return .alert(authError.rawValue, authError.localizedDescription)
    }
}
