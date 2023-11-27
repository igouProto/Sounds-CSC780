//
//  User.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var id: UUID
    var userUID: String
    var userEmail: String
    var userName: String
    var userDispName: String
    var userBio: String
    var userPfpURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case userUID
        case userEmail
        case userName
        case userDispName
        case userBio
        case userPfpURL
    }
}
