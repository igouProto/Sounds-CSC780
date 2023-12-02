//
//  PostCard.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct PostCard: View {
    
    var post: Post
    
    let user: User
    
    // callbacks
    var onUpdate: (Post) -> () // for liking posts
    var onDelete: () -> ()
    
    // update post status
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        
        // custom date parser
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd HH:mm"
            return formatter
        }()
        
        VStack(alignment: .leading){
            // user + timestamp
            HStack{
                HStack{
                    Image("DefaultPFP")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    VStack (alignment: .leading, spacing: 5){
                        Text(post.userDispName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("@\(post.userName)")
                            .foregroundStyle(.gray)
                    }
                    
                }
                
                Text(dateFormatter.string(from: post.date))
                    .hAlign(.trailing)
                    .vAlign(.top)
                    .foregroundStyle(.gray)
                
            }
            .padding(.vertical, 15)
            
            // post text + music embed
            VStack(alignment: .leading){
                Text(post.contentText)
                    .textSelection(.enabled)
                    .padding(.vertical, 6)
                
                // TODO: Song embed goes here
                if (post.songAttachment != nil){
                    MusicEmbed(song: post.songAttachment)
                }
            }
            .padding(.bottom, 10)
            
            // place like + delete button here
            HStack{
                
                Like()
                
                if post.userUID == user.userUID{
                    // give option to remove post if the current user is the author
                    Menu{
                        Button("Delete", role: .destructive, action: deletePost)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .foregroundStyle(.black)
                            .contentShape(Rectangle())
                    }
                    .hAlign(.trailing)
                }
            }
            
            
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
        .onAppear{ // add listener only once when card is in sight
            if docListener == nil {
                // print("Listener of Card added post \(String(describing: post.id)) added")
                guard let postID = post.id else { return }
                docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot {
                        if snapshot.exists{ // doc was updated
                            // get updated doc
                            if let updatedPost = try? snapshot.data(as: Post.self){
                                onUpdate(updatedPost)
                            }
                        }else{ // doc was removed
                            onDelete()
                        }
                    }
                    
                })
            }
        }
        .onDisappear{ // stop listening when card is out of sight
            if docListener != nil{
                docListener?.remove()
                // print("Listener of Card for post \(String(describing: post.id)) removed")
                docListener = nil
            }
        }
    }
    
    // Liking a post
    @ViewBuilder
    func Like() -> some View {
        HStack(spacing: 8){
            Button(action: likePost) {
                Image(systemName: post.likedUIDs.contains(user.userUID) ?  "heart.fill" : "heart")
            }
            
            Text("\(post.likedUIDs.count)")
        }
        .foregroundStyle(.black)
    }
    
    func likePost() {
        guard let postID = post.id else { return }
        print("tapped like on post \(postID)")
        // unlike if liked, like if unliked
        Task{
            // print(post.likedUIDs)
            if post.likedUIDs.contains(user.userUID) {
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedUIDs": FieldValue.arrayRemove([user.userUID])
                ])
            }else{
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedUIDs": FieldValue.arrayUnion([user.userUID])
                ])
            }
        }
    }
    
    // removing a post
    func deletePost() {
        Task{
            do {
                guard let postID = post.id else { return }
                try await Firestore.firestore().collection("Posts").document(postID).delete()
                print("Post \(postID) removed!")
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
