//
//  CreatePostView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    
    @Binding var isAddingView: Bool
    
    @StateObject var imagePicker = ImagePicker()
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
                Group {
                    CustomTextSection(sectionTitle: "title", placeholderText: "post title")
                    CustomTextSection(sectionTitle: "location", placeholderText: "general location of photos")
                    photoSection
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
                Text("Select Photos")
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
                                        ZStack{
                                            Circle()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.red)
                                            Image(systemName: "xmark")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                        }
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
    
    private var createOrModifyButton: some View {
        Button {
            
        } label: {
            Text("create post")
        }
        .buttonStyle(.bordered)
        .tint(.verloGreen)
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
            Divider()
        }
    }
}
