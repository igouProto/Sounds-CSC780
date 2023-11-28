//
//  UserContentView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import SwiftUI

struct UserContents: View {
    
    var profile: User
    
    var body: some View {
        VStack{
            Text("My Posts")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .hAlign(.leading)
                .padding(.vertical, 20)
            
        }
        .padding(20)
        
    }
}
