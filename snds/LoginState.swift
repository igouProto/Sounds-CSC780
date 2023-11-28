//
//  LoginState.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/27.
//

import Foundation

enum LoginState {
    // case error(Error)
    // case loading
    case loggedOut
    case loggedIn(User)
    
    init() {
        self = .loggedOut
    }
}
