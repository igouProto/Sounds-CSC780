//
//  Post.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/28.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    var id: UUID
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
    // var song = Song? // TODO: find an API (i.e. Spotify, Genius, YT?) that gives information of songs
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case likedUIDs
        case contentText
        case userName
        case userDispName
        case userUID
    }
}
