//
//  CreatePostView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

struct CreatePostView: View {
    
    //Presenting this sheet
    @Binding var isAddingView: Bool
    
    //Location Picker
    @State private var showLocationPicker = false
    @State private var coordinates = CLLocationCoordinate2D(latitude: 42.44333, longitude: -76.50000)
//    @State private var coordinates = CLLocationCoordinate2D(latitude: 10.5739475, longitude: -15.50000)

    
    //Image Picker
    @StateObject var imagePicker = ImagePicker()
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
                Group {
                    CustomTextSection(sectionTitle: "title", placeholderText: "post title")
                    CustomTextSection(sectionTitle: "approximate location", placeholderText: "general location of photos")
                    photoSection
                    mapSection
                }
                .padding(.horizontal)
                
                createOrModifyButton
                
                Spacer()
            }
            .padding(.top, 10)
            
            .navigationTitle("new post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backArrowButton
                }
            }
            .sheet(isPresented: $showLocationPicker) {
                NavigationView {
                    LocationPicker(instructions: "tap somewhere to select your coordinates", coordinates: $coordinates)
                        .navigationTitle("select location")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(leading: mapCloseButton, trailing: mapSaveButton)
                }
            }
        }
    }
}


extension CreatePostView {
    private var backArrowButton: some View {
        Button {
            isAddingView = false
        } label: {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                Image(systemName: "arrow.left")
                    .foregroundColor(.verloGreen)
            }
        }
    }
    
    private var addPhotosButton: some View {
        PhotosPicker(selection: $imagePicker.imageSelections,
                     maxSelectionCount: 10,
                     matching: .images,
                     photoLibrary: .shared()) {
            HStack{
                Text("select photos")
                Image(systemName: "photo.on.rectangle.angled")
                    .imageScale(.large)
            }
        }
    }
    
    private var selectedImagesGrid: some View {
        VStack {
            if !imagePicker.images.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<imagePicker.images.count, id: \.self) { index in
                            imagePicker.images[index]
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    Button{
                                        imagePicker.removePhoto(index: index)
                                    } label: {
                                        redXMarkButton
                                    }
                            }
                        }
                    }
                    .padding(.top)
                }
            } else {
                Text("add photos to post.")
            }
        }
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading){
            Text("photos")
                .font(.headline)
                .fontWeight(.bold)
            addPhotosButton
            selectedImagesGrid
            
        }
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading) {
            Text("map location")
                .font(.headline)
                .fontWeight(.bold)
            
            Button {
                self.showLocationPicker.toggle()
            } label: {
                HStack{
                    Image(systemName: "map")
                    Text("select location")
                }
            }
            
            Divider()

        }
    }
    
    private var mapCloseButton: some View {
        Button {
            self.showLocationPicker.toggle()

        } label : {
            Text("close")
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
    
    
    private var mapSaveButton: some View {
        Button {
            self.showLocationPicker.toggle()

        } label : {
            Text("save")
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        }
    }

private var mapSelectLocationText: some View {
    Text("select location")
        .font(.subheadline)
        .fontWeight(.bold)
        .background(.ultraThinMaterial)
}
    
    private var createOrModifyButton: some View {
        Button {
            
        } label: {
            Text("create post")
        }
        .buttonStyle(.bordered)
        .tint(.green)
    }
    
    private var redXMarkButton: some View {
        ZStack{
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(.red)
            Image(systemName: "xmark")
                .font(.caption)
                .foregroundColor(.white)
            
        }
    }


struct CustomTextSection: View {
    
    @State private var exampleText1: String = ""
    
    var sectionTitle: String
    var placeholderText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(sectionTitle)
                .font(.headline)
                .fontWeight(.bold)
            TextField(placeholderText, text: $exampleText1)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: exampleText1.count)

            Divider()
        }
    }
    
struct CharactersRemainView: View {
        
        var currentCount: Int
        
        var body: some View {
//            Text("Characters Remaining: ")
//                .font(.callout)
//                .foregroundColor(.secondary)
//                +
                Text("\(30 - currentCount)")
                .bold()
                .font(.callout)
                .foregroundColor(currentCount <= 30 ? .green : Color(.systemPink))
                +
                Text(" characters remain")
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }

}
