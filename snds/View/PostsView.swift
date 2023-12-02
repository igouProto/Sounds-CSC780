//
//  PostsView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/27.
//

import SwiftUI
import Firebase

struct PostsView: View {
    
    let user: User
    
    // control login state
    @Binding
    var loggedInState: LoginState
    
    // control showing writing post view or not
    @State
    var writingPost: Bool = false
    
    // list of posts to show
    @State
    private var recentPosts: [Post] = []
    
    @State
    var isFetching: Bool = false
    
    var body: some View {
        
        NavigationStack{
            
            PostsContainer(user: user, posts: $recentPosts, fetchingByUID: false)
                .hAlign(.center)
                .vAlign(.center)
                .overlay(alignment: .bottomTrailing){
                    Button {
                        writingPost.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(15)
                            .background(.black, in: Circle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .navigationTitle("Posts")
        }
        .fullScreenCover(isPresented: $writingPost, content: {
            NewPostView(onPost: { newPost in
                recentPosts.insert(newPost, at: 0)
            }, user: user, writingPost: $writingPost)
        })
    }
    
    // getting posts
    func fetchPosts() async {
        do {
            var query: Query!
            
            query = Firestore.firestore().collection("Posts").order(by: "date", descending: true).limit(to: 10)
            
            let docs = try await query.getDocuments()
            
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                
                try? doc.data(as: Post.self)
                
            }
            
            await MainActor.run(body: {
                recentPosts = fetchedPosts
                isFetching = false
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

/*
 #Preview {
 PostsView()
 }
 */
