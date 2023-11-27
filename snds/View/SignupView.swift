//
//  SignupView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
//

import SwiftUI
import PhotosUI

import Firebase
import FirebaseStorage
import FirebaseFirestore

struct SignupView: View {
    @State
    var emailID: String = ""
    
    @State
    var userName: String = ""
    
    @State
    var password: String = ""
    
    // user profile stuff
    @State
    var displayName: String = ""
    
    @State
    var bio: String = ""
    
    @State
    var userPFP: Data?
    
    // control showing views
    @Binding var signingUp: Bool
    @State var showImgPicker: Bool = false
    @State var pfpSelected: PhotosPickerItem?
    
    // error handling
    @State var showError: Bool = false
    @State var errorMsg: String = ""
    
    // control login state
    @Binding
    var loggedInState: LoginState
    
    var body: some View {
        Spacer()
        VStack{
            Image("LandingPageLogo")
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            Text("Make an account").foregroundStyle(.gray).hAlign(.leading)
            TextField("Email", text: $emailID)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            TextField("Username", text: $userName)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            SecureField("Password", text: $password)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
            Text("Setup Profile").foregroundStyle(.gray).hAlign(.leading)
            // the PFP
            ZStack{
                if let userPFP, let image = UIImage(data: userPFP){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{ // use the default one
                    Image("DefaultPFP")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 75, height: 75)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            /*
            .onTapGesture {
                showImgPicker.toggle()
            }
            */
            
            TextField("Display Name", text: $displayName)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            TextField("One Line Bio", text: $bio)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            
            Button(action: register) {
                Text("Sign Up")
                    .tint(.white)
                    .hAlign(.center)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
            }
            .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
            .disabledElement(userName == "" || emailID == "" || password == "")
            
        }
        .alert(errorMsg, isPresented: $showError, actions: {})
        .padding(50)
        .vAlign(.center)
        /*
        .photosPicker(isPresented: $showImgPicker, selection: $pfpSelected)
        .onChange(of: pfpSelected, perform: { selectedPFP in
            // extract PFP from user's selection
            if let selectedPFP {
                Task{
                    do {
                        guard let img = try await selectedPFP.loadTransferable(type: Data.self) else { return }
                        // update UI on the main thread
                        await MainActor.run(body: {userPFP = img})
                    }catch {
                        return
                    }
                }
            }
        })
        */
        
        HStack {
            Button("Back to Login") {
                signingUp = false
            }
        }
        .padding(50)
    }
    
    
    func register () {
        Task {
            do {
                // make a firebase acc.
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                // upload pfp to firebase storage
                /*
                guard let img = userPFP else { return }
                let storageReference = Storage.storage().reference().child("PFPs").child(userUID)
                let _ = try await storageReference.putDataAsync(img)
                
                // get pfp url from firebase
                let pfpURL = try await storageReference.downloadURL()
                */
                
                // make a user object to be pushed to Firestore
                let registeringUser = User(id: UUID(), userUID: userUID, userEmail: emailID, userName: userName, userDispName: displayName, userBio: bio, userPfpURL: URL(string: "https://example.com")!)
                
                // save the user to firestore
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: registeringUser, completion: { error in
                    if error == nil { // no error -> user saved successsfully
                        print("Create user succeeded!")
                        
                        // log the registering user in upon acc. creation
                        loggedInState = .loggedIn(registeringUser)                        
                    }else {
                        print(error ?? "error??")
                    }
                    
                })
            }catch{
                await showError(error)
            }
        }
    }
    
    // error message with alert
    func showError(_ err: Error) async {
        await MainActor.run(body: {
            errorMsg = err.localizedDescription
            showError.toggle()
        })
    }
}

/*
 #Preview {
     SignupView(emailID: "", signingUp: .constant(true))
*/

