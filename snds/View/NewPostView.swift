//
//  NewPost.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import SwiftUI

import Firebase
import FirebaseStorage

struct NewPostView: View {
    
    var onPost: (Post) -> ()
    
    // currently composing post
    @State
    private var postText: String = ""
    
    // current user info
    let user: User
    
    // control showing this view
    @Binding var writingPost: Bool
    
    // pending firebase resp
    @State var pending: Bool = false
    
    // error handling
    @State var showError: Bool = false
    @State var errorMsg: String = ""
    
    // for hiding keyboard on hitting "done"
    @FocusState private var showKB: Bool
    
    // for searching song info and choosing a song
    @State var searchingForSong: Bool = false
    @State var chosenSong: Song? = nil
    
    var body: some View {
        
        VStack{
            
            HStack{
                Menu{
                    Button("Cancel", role: .destructive) {
                        writingPost = false
                    }
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundStyle(.black)
                }
                .hAlign(.leading)
                
                Button(action: post, label: {
                    Text("Post")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.black, in: Capsule())
                })
                .disabledElement(postText == "")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                Rectangle()
                    .fill(.gray .opacity(0.1))
                    .ignoresSafeArea()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    TextField("What are you listening to?", text: $postText, axis: .vertical)
                        .focused($showKB)
                    
                    //TODO: show a song embed if song info is provided
                    if ((chosenSong) != nil){
                        VStack(alignment: .leading){
                            MusicEmbed(song: chosenSong ?? nil)
                            Button("Remove"){
                                chosenSong = nil
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
            }
            
            Divider()
            
            HStack{
                Button {
                    showKB = false
                    searchingForSong = true
                    
                } label: {
                    Image(systemName: "music.note.list")
                    Text("Attach Song")
                }
                .hAlign(.leading)
                
                Button {
                    showKB = false
                } label: {
                    Text("Done")
                }
                .hAlign(.trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)

        }
        .alert(errorMsg, isPresented: $showError, actions: {})
        .overlay(alignment: .center){
            if pending == true {
                ProgressView()
            }
        }
        .sheet(isPresented: $searchingForSong){
            SearchSongView(searchingForSong: $searchingForSong, chosenSong: $chosenSong)
        }
    }
    
    // post to firebase
    func post(){
        pending = true
        showKB = false
        Task {
            do {                
                let newpost: Post = Post(contentText: postText, userName: user.userName, userDispName: user.userDispName, userUID: user.userUID, songAttachment: chosenSong)
                
                try await createInFirebase(newpost)
                
            }catch {
                await showError(error)
            }
        }
    }
    
    func createInFirebase(_ post: Post) async throws {
        let docRef = try Firestore.firestore().collection("Posts").addDocument(from: post, completion: { error in
            pending = false
            if error != nil {
                print(error ?? "error?")
                return
            }
        })
        
        print("post saved to firebase!")
        // get the new post's ID and attach to the new post we created
        // this is for being able to interact with the new post when it
        // just got created w/o refreshing the entire feed
        var newPost = post
        newPost.id = docRef.documentID
        onPost(newPost)
        writingPost = false
    }
    
    // error message with alert
    func showError(_ err: Error) async {
        await MainActor.run(body: {
            errorMsg = err.localizedDescription
            showError.toggle()
        })
    }
}


