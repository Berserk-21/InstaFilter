//
//  ContentView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var blurAmount = 0.0 {
        didSet {
            print("New value is \(blurAmount)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("New value is \(newValue)")
                }
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
    }
}

#Preview {
    ContentView()
}
