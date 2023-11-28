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
        
        TabView {
            PostsView(user: user, loggedInState: $loggedInState)
                .tabItem {
                    Label("Posts", systemImage: "square")
                }
            
            ProfileView(user: user, profile: nil, loggedInState: $loggedInState)
                .tabItem {
                    Label("Profile", systemImage: "square")
                }
            
        }
        
    }
}
