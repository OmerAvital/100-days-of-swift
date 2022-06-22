//
//  ContentView.swift
//  Instafilter
//
//  Created by Omer Avital on 6/8/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

let ranges: [String: ClosedRange<Double>] = [
    kCIInputIntensityKey: 0...1,
    kCIInputRadiusKey: 1...150,
    kCIInputScaleKey: 0...10
]

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterValues = [FilterValue]()
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = .sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .onTapGesture {
                    showingImagePicker = true
                }
                
                Group {
                    ForEach(filterValues) { filterValue in
                        HStack {
                            Text(filterValue.name)
                            Slider(
                                value: $filterValues.first(where: { $0.id == filterValue.id })?.value ?? .constant(0.5),
                                in: filterValue.range
                            )
                        }
                        .onChange(of: filterValue.value) { _ in applyProcessing() }
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(processedImage == nil)
                }
            }
            .padding()
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(.crystallize()) }
                Button("Edges") { setFilter(.edges()) }
                Button("Gaussian Blur") { setFilter(.gaussianBlur()) }
                Button("Pixellate") { setFilter(.pixellate()) }
                Button("Sepia Tone") { setFilter(.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(.unsharpMask()) }
                Button("Vignette") { setFilter(.vignette()) }
                Button("Depth of Field") { setFilter(.depthOfField()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func setValue(_ value: Double, forKey key: String) {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(key) {
            currentFilter.setValue(value, forKey: key)
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        func filtered(_ array: [String]) -> [String] {
            array.filter({ item in
                ![kCIInputImageKey, kCIInputCenterKey].contains(item)
                && ranges.keys.contains(item)
            })
        }
        
        if filterValues.map({ $0.name }) != filtered(inputKeys) {
            filterValues = filtered(inputKeys)
                .map({ filterName in
                    if let range = ranges[filterName] {
                        return FilterValue(name: filterName, range: range)
                    } else {
                        return FilterValue(name: filterName)
                    }
                })
        }
        
        for filterValue in filterValues {
            setValue(filterValue.value, forKey: filterValue.name)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
