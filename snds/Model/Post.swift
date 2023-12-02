//
//  Post.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    // var imgURL: URL?
    // var imgRefID: String = ""
    var date: Date = Date()
    var likedUIDs: [String] = []
    var contentText: String
    
    // OP's info
    var userName: String
    var userDispName: String
    var userUID: String
    // var userProfileURL: URL
    
    // attachment - an embed to a song they're referencing
    var songAttachment: Song?
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case likedUIDs
        case contentText
        case userName
        case userDispName
        case userUID
        case songAttachment
    }
}
