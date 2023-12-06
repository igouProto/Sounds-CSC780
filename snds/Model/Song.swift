//
//  Song.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/12/2.
//

import Foundation

struct Song: Codable { // the song that will be attached to posts
    let title: String
    let url: String
    let songArtImageUrl: String
    let artistNames: String

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case songArtImageUrl = "song_art_image_url"
        case artistNames = "artist_names"
    }
}
