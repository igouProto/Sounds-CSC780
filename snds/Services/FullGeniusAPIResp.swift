//
//  FullGeniusAPIResp.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/12/1.
//

import Foundation

// for decoding the entire API response from Genius
// attribution: generated with ChatGPT
struct FullSongsResponse: Codable {
    let meta: Meta
    let response: Response
}

struct Meta: Codable {
    let status: Int
}

struct Response: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let highlights: [String]
    let index: String
    let type: String
    let result: SongResult
}

struct SongResult: Codable {
    let annotationCount: Int
    let apiPath: String
    let artistNames: String
    let fullTitle: String
    let headerImageThumbnailUrl: String
    let headerImageUrl: String
    let id: Int
    let lyricsOwnerId: Int
    let lyricsState: String
    let path: String
    let pyongsCount: Int?
    let relationshipsIndexUrl: String
    let releaseDateComponents: ReleaseDateComponents
    let releaseDateForDisplay: String
    let releaseDateWithAbbreviatedMonthForDisplay: String
    let songArtImageThumbnailUrl: String
    let songArtImageUrl: String
    let stats: Stats
    let title: String
    let titleWithFeatured: String
    let url: String
    let featuredArtists: [FeaturedArtist]
    let primaryArtist: PrimaryArtist
    
    enum CodingKeys: String, CodingKey {
        case annotationCount = "annotation_count"
        case apiPath = "api_path"
        case artistNames = "artist_names"
        case fullTitle = "full_title"
        case headerImageThumbnailUrl = "header_image_thumbnail_url"
        case headerImageUrl = "header_image_url"
        case id
        case lyricsOwnerId = "lyrics_owner_id"
        case lyricsState = "lyrics_state"
        case path
        case pyongsCount = "pyongs_count"
        case relationshipsIndexUrl = "relationships_index_url"
        case releaseDateComponents = "release_date_components"
        case releaseDateForDisplay = "release_date_for_display"
        case releaseDateWithAbbreviatedMonthForDisplay = "release_date_with_abbreviated_month_for_display"
        case songArtImageThumbnailUrl = "song_art_image_thumbnail_url"
        case songArtImageUrl = "song_art_image_url"
        case stats
        case title
        case titleWithFeatured = "title_with_featured"
        case url
        case featuredArtists = "featured_artists"
        case primaryArtist = "primary_artist"
    }
}

struct ReleaseDateComponents: Codable {
    let year: Int
    let month: Int
    let day: Int
}

struct Stats: Codable {
    let unreviewedAnnotations: Int
    let hot: Bool
    let pageviews: Int
    
    enum CodingKeys: String, CodingKey {
        case unreviewedAnnotations = "unreviewed_annotations"
        case hot
        case pageviews
    }
}

struct FeaturedArtist: Codable {
    // Define properties for FeaturedArtist if needed
}

struct PrimaryArtist: Codable {
    let apiPath: String
    let headerImageUrl: String
    let id: Int
    let imageUrl: String
    let isMemeVerified: Bool
    let isVerified: Bool
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case apiPath = "api_path"
        case headerImageUrl = "header_image_url"
        case id
        case imageUrl = "image_url"
        case isMemeVerified = "is_meme_verified"
        case isVerified = "is_verified"
        case name
        case url
    }
}
