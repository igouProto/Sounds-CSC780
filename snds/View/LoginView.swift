//
//  LoginView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State
    var emailID: String = ""
    
    @State
    var password: String = ""
    
    @State // show the sign up page or not
    var signingUp: Bool = false
    
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
            TextField("Email / Username", text: $emailID)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            SecureField("Password", text: $password)
                .padding(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            Button(action: signIn) {
                Text("Sign In")
                    .tint(.white)
                    .hAlign(.center)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    
            }
            .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(50)
        .vAlign(.center)
        .alert(errorMsg, isPresented: $showError, actions: {})
        
        HStack {
            Button("Sign Up") {
                signingUp.toggle()
            }
            .fullScreenCover(isPresented: $signingUp, content: {
                SignupView(emailID: emailID, signingUp: $signingUp, loggedInState: $loggedInState)
            })
            Text(" | ")
            Button(action: resetPassword) {
                Text("Forgot Password")
            }
        }
        .padding(50)
    }
    
    func signIn () {
        print("\(emailID), \(password)")
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found!")
                
                // fetch user info from firebase
                try await fetchUser()
                
            }catch{
                print(error)
                await showError(error)
            }
        }
    }
    
    func fetchUser () async throws {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        print("Fetching userID: \(userUID)")
        let foundUser = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
        
        await MainActor.run(body: {
            // switch login state
            loggedInState = .loggedIn(foundUser)
        })
    }
    
    func resetPassword () {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("PW reset request sent")
            }catch{
                print(error)
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
 LoginView()
 }
*/

