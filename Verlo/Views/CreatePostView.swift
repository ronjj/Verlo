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


//Enums
enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}


struct CreatePostView: View {
    
    //Presenting this sheet
    @Binding var isAddingView: Bool
    
    //Location Picker
    @State private var showLocationPicker = false
    @State private var coordinates = CLLocationCoordinate2D(latitude: 42.449317, longitude: -76.484366)
    @State var saveButtonClicked = false
    
    //Image Picker
    @StateObject var imagePicker = ImagePicker()
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    //Old Firebase
    @ObservedObject var viewModel = FirebasePostViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false

    
    
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Done" : "Save")
        }
        .disabled(!viewModel.modified)
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10){
                    Group {
                        TitleTextSection(sectionTitle: "title", placeholderText: "post title")
                        LocationTextSection(sectionTitle: "approximate location", placeholderText: "general location of photos")
                        photoSection
                        mapSection
                    }
                    .padding(.horizontal)
                    
                    createOrModifyButton
                    
                    if mode == .edit {
                        Button {
                            
                        } label : {
                            Text("delete post")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                .navigationTitle("new post")
                .actionSheet(isPresented: $presentActionSheet) {
                  ActionSheet(title: Text("Are you sure?"),
                              buttons: [
                                .destructive(Text("Delete book"),
                                             action: { self.handleDeleteTapped() }),
                                .cancel()
                              ])
                }
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
                    .tint(.red)
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
            Divider()
            
        }
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("map location")
                .font(.headline)
                .fontWeight(.bold)
            
            Button {
                self.showLocationPicker.toggle()
            } label: {
                HStack{
                    Image(systemName: "map")
                    Text(saveButtonClicked ? "selected location:" : "tap to select a location")
                }
            }
            .tint(saveButtonClicked ? .green : .red)
            
            if saveButtonClicked {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))))
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(30)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity)
        
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
            self.saveButtonClicked = true
            
        } label : {
            Text("save")
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
    
    private var mapSelectLocationText: some View {
        Text("select location")
            .font(.subheadline)
            .fontWeight(.bold)
            .background(.ultraThinMaterial)
    }
    
    private var createOrModifyButton: some View {
        Button {
            self.handleDoneTapped()
        } label: {
            Text(mode == .new ? "create post" : "save changes")
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
    
    //MARK: Action Handlers
    func handleCancelTapped() {
        self.dismiss()
    }
    
    func handleDoneTapped() {
        self.viewModel.handleDoneTapped()
        self.dismiss()
    }
    
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}





struct TitleTextSection: View {
    
    @ObservedObject var viewModel = FirebasePostViewModel()
    
    var sectionTitle: String
    var placeholderText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(sectionTitle)
                .font(.headline)
                .fontWeight(.bold)
            TextField(placeholderText, text: $viewModel.post.title)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: viewModel.post.title.count)
            
            Divider()
        }
    }
}

struct LocationTextSection: View {
    
    @ObservedObject var viewModel = FirebasePostViewModel()
    
    var sectionTitle: String
    var placeholderText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(sectionTitle)
                .font(.headline)
                .fontWeight(.bold)
            TextField(placeholderText, text: $viewModel.post.locationText)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: viewModel.post.locationText.count)
            
            Divider()
        }
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
    

    
    
