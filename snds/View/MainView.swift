//
//  MainView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/27.
//

import SwiftUI

struct MainView: View {
    
    let user: User
    
    // control login state
    @Binding
    var loggedInState: LoginState
    
    var body: some View {
        Text("Logged in as: \(user.userName)")
        Button(action: logout, label: {
            Text("Logout")
        })
    }
    
    func logout () {
        loggedInState = .loggedOut
    }
}
