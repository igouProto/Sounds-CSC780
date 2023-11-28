//
//  PostsView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/27.
//

import SwiftUI

struct PostsView: View {
    
    let user: User
    
    // control login state
    @Binding
    var loggedInState: LoginState
    
    var body: some View {
        
        Text("(Post) Logged in as: \(user.userName)")
        
    }
}

/*
 #Preview {
 PostsView()
 }
 */
