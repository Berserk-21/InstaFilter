//
//  ImageModifierView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageModifierView: View {
    
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?.resizable()
                .scaledToFit()
        }
        .onAppear(perform: {
            loadImage()
        })
    }
    
    func loadImage() {
        
        let inputImage = UIImage(resource: .rollerCoasterBitcoin)
        // image recipe
        let beginImage = CIImage(image: inputImage)
        
        // apply modifications
        let context = CIContext()
        let currentFilter = CIFilter.pixellate()
        currentFilter.inputImage = beginImage
        
        let amount = 25
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        //
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ImageModifierView()
}
