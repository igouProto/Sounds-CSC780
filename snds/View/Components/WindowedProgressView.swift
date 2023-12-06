//
//  WindowedProgressView.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/12/5.
//

import SwiftUI

struct WindowedProgressView: View {
    var body: some View {
        ZStack {
            // Background rectangle to simulate a window
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .border(.gray)
                .frame(width: 50, height: 50)
            
            // ProgressView overlaid on top of the background
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .hAlign(.center)
                .vAlign(.center)
        }
    }
}
