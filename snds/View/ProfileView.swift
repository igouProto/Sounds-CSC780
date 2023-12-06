//
//  ProfileView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/27.
//
// attribution - part of this file was adapted from this tutorial series:
// https://www.youtube.com/playlist?list=PLimqJDzPI-H9u3cSJCPB_EJsTU8XP2NUT

import SwiftUI

import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    
    // the current user and the profile to show
    let user: User
    @State var profile: User?
    
    // control login state
    @Binding var loggedInState: LoginState
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView(.vertical) {
                if let profile{
                    
                    VStack{
                        ProfileCard(user: profile)
                            .hAlign(.center)
                            .padding(.horizontal, 15)
                        
                        UserContents(user: profile)
                    }
                    
                }else{
                    ProgressView()
                }
                
            }
            .navigationTitle("Profile")
            .refreshable {
                // fetch user data again on pull down to refresh
                self.profile = nil
                await fetchUser()
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Menu {
                        Button(action: logout, label: { Text("Logout") })
                    } label: {
                        Image(systemName: "gear")
                            .scaleEffect(0.8)
                            .tint(.black)
                    }
                }
            }
        }
        .task {
            if profile != nil { return }
            
            await fetchUser()
        }
    }
    
    // fetch user data
    func fetchUser () async {
        
        let userUID = Auth.auth().currentUser?.uid ?? user.userUID
        // shouldn't be falling back to the dummy's ID in real usage
        
        print("Fetching profile for: ", userUID)
        
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else { return }
        
        print("Fetched user: ", user)
        
        await MainActor.run(body: {
            profile = user
        })
    }
    
    // logout
    func logout () {
        do {
            try Auth.auth().signOut()
            loggedInState = .loggedOut
        } catch {
            print(error)
        }
    }
}
