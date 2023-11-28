//
//  ContentView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State
    // var loginState: LoginState = .loggedOut
    var loginState: LoginState = .loggedIn(dummyUser)
    
    var body: some View {
        switch loginState {
        case .loggedOut:
            LoginView(loggedInState: $loginState)
        case .loggedIn(let user):
            MainView(user: user, loggedInState: $loginState)
        }
    }
}

/*
 #Preview {
 ContentView()
 .modelContainer(for: Item.self, inMemory: true)
 }
 */
