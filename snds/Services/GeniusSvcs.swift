//
//  GeniusSvcs.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/12/1.
//

import Foundation

enum SvcError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case deviceErr // like no internet
    
    var desc: String{
        switch self{
            case .invalidURL: return "Invalid URL!"
            case .decodingError: return "Invalid server response!"
            case .noData: return "No data from the servers!"
            case .deviceErr: return "No internet connection!"
        }
    }
}

struct Constants {
    static var clientToken: String = "BMfnB54SdlsnjaiNeuCjzF8vbjO-aRRfX1o4qGg1pMW9cJenl1uO-yNldKRUN1Ff"
    static var url: String = "https://api.genius.com/search?access_token=\(clientToken)&q="
}

// attribution: generated with ChatGPT
struct SongsResponse: Codable {
    let meta: Meta
    
    struct Meta: Codable {
        let status: Int
    }
    
    let response: Response
    
    struct Response: Codable {
        let hits: [Hit]

        struct Hit: Codable {
            let result: SongResult

            struct SongResult: Codable {
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
        }
    }    
}

// the service interface
struct GeniusSvcs {
    
    func searchForSongs(_ query: String) async throws -> [Song] {
        
        let urlString = Constants.url + query
        guard let url = URL(string: urlString) else {
            throw SvcError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        do {
            let songsResp = try decoder.decode(SongsResponse.self, from: data)
            // print(songsResp)
            
            let songs = songsResp.response.hits.compactMap{ hit -> Song? in
                let songRes = hit.result
                
                return Song(title: songRes.title, url: songRes.url, songArtImageUrl: songRes.songArtImageUrl, artistNames: songRes.artistNames)
            }
            
            return songs
            
        }catch{
            print(error)
            throw SvcError.decodingError(error)
        }
    }
}
