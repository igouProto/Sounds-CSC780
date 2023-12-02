//
//  ProfileCard.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import SwiftUI

struct ProfileCard: View {
    
    var user: User
    
    var body: some View {
        VStack{
                Image("DefaultPFP")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                VStack (alignment: .center, spacing: 6){
                    Text(user.userDispName)
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("@\(user.userName)")
                        .foregroundStyle(.gray)
                    Text(user.userBio)
                }
            }
    }
}
