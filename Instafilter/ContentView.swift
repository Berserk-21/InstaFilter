//
//  ContentView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var showingFilters = false
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.crystallize()
    let context = CIContext()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                                .foregroundStyle(Color(white: 0.0, opacity: processedImage == nil ? 0.25 : 1.0))
                            Slider(value: $filterIntensity)
                                .onChange(of: filterIntensity, applyProcessing)
                        }
                    }

                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                                .foregroundStyle(Color(white: 0.0, opacity: processedImage == nil ? 0.25 : 1.0))
                            Slider(value: $filterRadius)
                                .onChange(of: filterRadius, applyProcessing)
                        }
                    }

                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            Text("Scale")
                                .foregroundStyle(Color(white: 0.0, opacity: processedImage == nil ? 0.25 : 1.0))
                            Slider(value: $filterScale)
                                .onChange(of: filterScale, applyProcessing)
                        }
                    }
                    
                    HStack {
                        Button("Change Filter", action: changeFilter)
                        
                        Spacer()
                        
                        if let processedImage {
                            ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                        }
                    }
                }
                .disabled(processedImage == nil)

                
                Spacer()
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Selectet a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Gloom") { setFilter(CIFilter.gloom()) }
                Button("Bloom") { setFilter(CIFilter.bloom()) }
                Button("Pointillize") { setFilter(CIFilter.pointillize()) }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func changeFilter() {
        showingFilters.toggle()
    }
    
    func loadImage() {
        
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            
            guard let uiImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: uiImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            
            currentFilter.setValue(max(0,001, filterScale * 100), forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            
            var value: CGFloat = filterRadius
            
            if let filterName = currentFilter.attributes["CIAttributeFilterName"] as? String {
                switch filterName {
                case "CIVignette":
                    value *= 2.0
                case "CICrystallize":
                    value *= 200.0
                case "CIGaussianBlur":
                    value *= 50.0
                case "CIPointillize":
                    value = (max(1, value * 20))
                default:
                    value *= 20.0
                }
            }
            
            currentFilter.setValue(value, forKey: kCIInputRadiusKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        if filterCount >= 20 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
