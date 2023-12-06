//
//  MusicEmbed.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/29.
//
// attribution: The album art loading functions below the MusicEmbed View
// was generated with ChatGPT

import SwiftUI
import Combine

struct MusicEmbed: View {
    
    var song: Song?
    
    @StateObject var imgLoader = ImageLoader()
    
    var body: some View {
        HStack{
            
            HStack{
                if let imageUrl = song?.songArtImageUrl, let url = URL(string: imageUrl) {
                        AsyncImageView(url: url)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                } else {
                    Image(systemName: "music.note")
                        .font(.title)
                        .foregroundStyle(.gray)
                        .frame(width: 60, height: 60)
                        .padding(.horizontal, 10)
                }
                
                VStack (alignment: .leading){
                    Text(song?.title ?? "")
                    Text(song?.artistNames ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                }
                Spacer()
            }
            .cornerRadius(10)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            
        }
        .border(.gray)
        .padding(.vertical, 10)
        .onTapGesture {
            if let urlString = song?.url, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
        .onAppear {
            if let imageUrl = song?.songArtImageUrl, let url = URL(string: imageUrl) {
                imgLoader.loadImage(from: url)
            }
        }
    }
}

// album art loader functions
class ImageLoader: ObservableObject {
    @Published var imageData: Data?
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
}

struct AsyncImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(url: URL) {
        imageLoader = ImageLoader()
        imageLoader.loadImage(from: url)
    }
    
    var body: some View {
        if let imageData = imageLoader.imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            ProgressView()
        }
    }
}
