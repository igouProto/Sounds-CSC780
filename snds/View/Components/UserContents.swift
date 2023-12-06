//
//  UserContentView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import SwiftUI

struct UserContents: View {
    
    var user: User
    
    @State private var recentPosts: [Post] = []
    
    var body: some View {
        VStack{
            Text("My Posts")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .hAlign(.leading)
                .padding(20)
            
            PostsContainer(user: user, posts: $recentPosts, fetchingByUID: true, fetchUserUID: user.userUID)
            
        }        
    }
}
