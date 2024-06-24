//
//  ContentView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select a picture", systemImage: "photo")
            }
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onChange(of: pickerItems) { oldValue, newValue in
            Task {
                selectedImages.removeAll()
                
                for item in pickerItems {
                    if let loadedImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
