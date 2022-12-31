//
//  CreatePostView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI
import PhotosUI
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
    
    //New Firebase 10.0 - For Pulling Posts
    @FirestoreQuery(collectionPath: "posts") var posts: [Post]

    //Old Firebase - For Creating Posts and Adding to Collection
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel = FirebasePostViewModel()
    @State var presentActionSheet = false
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10){
                    Group {
                        titleTextField
                        locationTextField
                        photoSection
                        mapSection
                        
                    }
                    .padding(.horizontal)
                    
                    createOrModifyButton
                        .disabled(viewModel.post.title.isEmpty || viewModel.post.locationText.isEmpty || viewModel.post.title.count > 30 || viewModel.post.locationText.count > 30 || !saveButtonClicked)
//                    """
//                    Disabled if:
//                    - title is empty
//                    - location is empty
//                    - title is over 30 characters
//                    - location is over 30 characters
//                    - no photos are selected
//                    - no coordinates are selected
                    // Eventuslly switch this to show an error with the corresponding issue
//                    """
                       
                    
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
                if imagePicker.images.isEmpty {
                    noImagesSelected
                } else {
                    editImagesSelected
                }
            }
        }
         .buttonStyle(.bordered)
         .tint(imagePicker.images.isEmpty ? .red : .orange)
    }
    
    private var noImagesSelected: some View {
        HStack{
            Image(systemName: "photo.on.rectangle.angled")
            Text("tap to select up to 10 images:")
        }
    }
    
    private var editImagesSelected: some View {
        HStack{
            Image(systemName: "square.and.pencil")
            Text("edit selected images")
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
            }
//            else {
//                Text("no photos selected")
//                    .foregroundColor(.secondary)
//            }
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
        VStack(alignment: .leading, spacing: 10) {
            Text("map location")
                .font(.headline)
                .fontWeight(.bold)
            
            Button {
                self.showLocationPicker.toggle()
            } label: {
                HStack{
                    if saveButtonClicked {
                        editMapSelection
                    } else {
                        chooseMapSelection
                    }
                }
            }
            .tint(saveButtonClicked ? .orange : .red)
            .buttonStyle(.bordered)
            
            if saveButtonClicked {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))), annotationItems: posts) { post in
                    MapMarker(coordinate: coordinates)
                }
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(30)
                    .allowsHitTesting(false)
                    
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var editMapSelection: some View {
        HStack{
            Image(systemName: "square.and.pencil")
            Text("edit selection:")
        }
    }
    
    private var chooseMapSelection: some View {
        HStack{
            Image(systemName: "map")
            Text("tap to select a location:")
        }
    }
    
    private var titleTextField: some View {
        VStack(alignment: .leading) {
            Text("title")
                .font(.headline)
                .fontWeight(.bold)
            TextField("post title", text: $viewModel.post.title)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: viewModel.post.title.count)
            
            Divider()
        }
    }
    
    private var locationTextField: some View {
        VStack(alignment: .leading) {
            Text("approximate location")
                .font(.headline)
                .fontWeight(.bold)
            TextField("general location of photos", text: $viewModel.post.locationText)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: viewModel.post.locationText.count)
            
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
            self.saveButtonClicked = true
            viewModel.post.lattitude = coordinates.latitude
            viewModel.post.longitude = coordinates.longitude
            
            
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
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .frame(width: UIScreen.main.bounds.width)
        .padding()
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
    

    
    
