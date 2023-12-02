//
//  PostsContainer.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import SwiftUI
import Firebase

struct PostsContainer: View {
    
    let user: User
    
    @Binding
    var posts: [Post]
    
    @State var isFetching: Bool = true
    
    // pagination
    @State private var lastFetched: QueryDocumentSnapshot?
    
    // are we fetching for the entire db or just a user?
    var fetchingByUID: Bool
    var fetchUserUID: String?
    
    var body: some View {
        ScrollView(.vertical){
            LazyVStack{
                if isFetching {
                    ProgressView()
                        .hAlign(.center)
                        .vAlign(.center)
                }else{
                    if posts.isEmpty{
                        // no posts found
                        Text("No Posts Found!")
                            .foregroundStyle(.gray)
                    }else{
                        // show posts
                        Posts()
                    }
                }
            }
        }
        .refreshable {
            // pull to refresh
            isFetching = true
            posts = []
            lastFetched = nil
            await fetchPosts()
        }
        .padding(.horizontal, 20)
        .task {
            // fetch posts on appear
            guard posts.isEmpty else { return }
            
            await fetchPosts()
        }
    }
    
    // getting posts
    func fetchPosts() async {
        do {
            var query: Query?
            
            // pagination: start fetching from what we left off before
            if let lastFetched {
                query = Firestore.firestore().collection("Posts").order(by: "date", descending: true).start(afterDocument: lastFetched).limit(to: 10)
            } else {
                query = Firestore.firestore().collection("Posts").order(by: "date", descending: true).limit(to: 10)
            }
            
            // filter posts that's not from this UID if provided
            if fetchingByUID {
                // print("Fetching user \(fetchUserUID ?? "")'s posts")
                query = query?.whereField("userUID", isEqualTo: fetchUserUID ?? "" as Any)
            }
            
            guard let safeQuery = query else { return }
            let docs = try await safeQuery.getDocuments()
            
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                
                try? doc.data(as: Post.self)
            }
            
            await MainActor.run(body: {
                // posts = fetchedPosts
                posts.append(contentsOf: fetchedPosts)
                
                // save the last fetched post for pagination
                lastFetched = docs.documents.last
                
                isFetching = false
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCard(post: post, user: user) { updatedPost in
                // update post in array
                if let idx = posts.firstIndex(where: {post in
                    return post.id == updatedPost.id
                }){
                    posts[idx].likedUIDs = updatedPost.likedUIDs
                }
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.5)){
                    posts.removeAll(where: { return post.id == $0.id })
                }
            }
            .onAppear{
                // load more when last fetched post appears
                if post.id == posts.last?.id && lastFetched != nil {
                    // print("Fetching new posts")
                    Task {
                        await fetchPosts()
                    }
                }
            }
            
            Divider()
                .padding(.horizontal, -15)
        }
    }
    
}
