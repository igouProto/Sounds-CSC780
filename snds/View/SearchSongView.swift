//
//  SearchSongView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/12/1.
//

import SwiftUI

struct SearchSongView: View {
    
    let svc = GeniusSvcs()
    
    @State private var queryText: String = ""
    @State private var results: [Song] = []
    
    // control showing this view
    @Binding var searchingForSong: Bool
    
    // pending api resp
    @State var pending: Bool = true
    
    // the chosen song
    @Binding var chosenSong: Song?
    
    var body: some View {
        VStack{
            
            VStack{
                HStack{
                    Button("Cancel") {
                        searchingForSong = false
                    }
                    .foregroundStyle(.black)
                    .hAlign(.leading)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
                .background {
                    Rectangle()
                        .fill(.gray .opacity(0.1))
                        .ignoresSafeArea()
                }
                .padding(.bottom, 20)
                
                SearchBar(text: $queryText, onSearch: {
                    Task {
                        results = try await svc.searchForSongs(queryText)
                    }
                })
                
                List(results, id: \.title) { song in
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.headline)
                        Text(song.artistNames)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .onTapGesture {
                        chosenSong = song
                        
                        // close the panel
                        searchingForSong = false
                    }
                }
            }
            .vAlign(.topLeading)
            
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search for a Song...", text: $text, onCommit: {
                onSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
            }
            .padding(.trailing)
        }
    }
}

