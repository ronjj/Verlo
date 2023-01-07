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
    
    //offline info
    @State var offlineTitle: String = ""
    @State var offlineLocation: String = ""
    @State var offlineLattitude: Double = 0.0
    @State var offlineLongitude: Double = 0.0
    @EnvironmentObject private var vm: PostViewModel

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
    
    //New
    var onPost: (Post)->()
    @AppStorage("user_name") var userName: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool
    
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
//
                        .disabled(offlineTitle.isEmpty || offlineLocation.isEmpty || offlineTitle.count > 30 || offlineLocation.count > 30 || !saveButtonClicked)

                    

                        
                    if offlineTitle.isEmpty || offlineLocation.isEmpty || offlineTitle.count > 30 || offlineLocation.count > 30 || !saveButtonClicked {

                        Label("all fields must be completed before posting", systemImage: "exclamationmark.triangle")
                            .foregroundColor(.red)
                    }
                    
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
                        LocationPicker(instructions: "tap somewhere to select your location", coordinates: $coordinates)
                            .navigationTitle("select location")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarItems(leading: mapCloseButton, trailing: mapSaveButton)
                    }
                }
            }
        }
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                        await MainActor.run(body: {
                            postImageData = compressedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay {
            LoadingView(show: $isLoading)
        }
    }
    func createPost() {
        isLoading = true
        showKeyboard = false
        
        Task {
            do {
                guard let profileURL = profileURL else {return}
                
                //Uploading image if selected
                let imageReferenceID = "\(userUID)\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                if let postImageData{
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    
                    //creating post object with image id and url
                    let post = Post(title: offlineTitle, imageURL: downloadURL, imageReferenceID: imageReferenceID ,  userName: userName, userUID: userUID, locationText: offlineLocation, lattitude: coordinates.latitude, longitude: coordinates.longitude, dateEvent: Date())
                    
                    try await createDocumentAtFirebase(post)
                    
                } else {
                    let post = Post(title: offlineTitle, userName: userName, userUID: userUID, locationText: offlineLocation, lattitude: coordinates.latitude, longitude: coordinates.longitude, dateEvent: Date())
                    try await createDocumentAtFirebase(post)
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Post)async throws {
        //writing documen to firebase firestore
        
        let doc = Firestore.firestore().collection("Posts").document()
        let _ = try doc.setData(from: post, completion: { error in
            if error == nil {
                isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                dismiss()
            }
        })
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}


extension CreatePostView {
    
    //MARK: Navigation
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
    
    private var createOrModifyButton: some View {
        Button {
            
            createPost()
        } label: {
            Text(mode == .new ? "create post" : "save changes")
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .frame(width: UIScreen.main.bounds.width)
        .padding()
    }
    
    //MARK: Photos
    private var photoSection: some View {
//        VStack(alignment: .leading, spacing: 5){
//            Text("photos")
//                .font(.headline)
//                .fontWeight(.bold)
//            addPhotosButton
////            addPhotosButtonSingular
//            selectedImagesGrid
//            Divider()
//
//        }
        VStack {
            
            Button {
                showImagePicker.toggle()
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.title3)
            }
            
            if let postImageData, let image = UIImage(data: postImageData) {
                GeometryReader{
                    let size = $0.size
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(alignment: .topTrailing) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    self.postImageData = nil
                                }
                            } label : {
                                Image(systemName: "xmark")
                                    .fontWeight(.bold)
                                    .tint(.red)
                            }
                            .padding(10)
                        }
                }
                
                .clipped()
                .frame(height: 220)
            }
        }
    }
    
    private var addPhotosButton: some View {
        PhotosPicker(selection: $viewModel.imageSelections,
                     maxSelectionCount: 10,
                     matching: .images,
                     photoLibrary: .shared()) {
            HStack{
                if viewModel.images.isEmpty {
                    noImagesSelected
                } else {
                    editImagesSelected
                }
            }
        }
         .buttonStyle(.bordered)
         .tint(viewModel.images.isEmpty ? .red : .orange)
    }
    
    private var addPhotosButtonSingular: some View {
        PhotosPicker(selection: $viewModel.imageSelection,
                     matching: .images,
                     photoLibrary: .shared()) {

        }
         .buttonStyle(.bordered)
//         .tint(imagePicker.images.isEmpty ? .red : .orange)
    }
    
    private var selectedImagesGrid: some View {
        VStack {
            if !viewModel.images.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<viewModel.images.count, id: \.self) { index in
                            viewModel.images[index]
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    Button{
                                        withAnimation(.easeInOut(duration: 0.20)) {
                                            viewModel.removePhoto(index: index)
                                        }
                                    } label: {
                                        redXMarkButton
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
//            else {
//                Text("no photos selected")
//                    .foregroundColor(.secondary)
//            }
        }
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
    
    private var noImagesSelected: some View {
        Label("tap to select up to 10 images:", systemImage: "photo.on.rectangle.angled")

    }
    
    private var editImagesSelected: some View {
        Label("edit selected images", systemImage: "square.and.pencil")

    }
    
    //MARK: Map
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var editMapSelection: some View {
        Label("edit selection:", systemImage: "square.and.pencil")
    }
    
    private var chooseMapSelection: some View {
        Label("tap to select a location:", systemImage: "map")
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
//            viewModel.post.lattitude = coordinates.latitude
//            viewModel.post.longitude = coordinates.longitude
            offlineLattitude = coordinates.latitude
            offlineLongitude = coordinates.longitude
            
            
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
    
    //MARK: Title
    
    private var titleTextField: some View {
        VStack(alignment: .leading) {
            Text("title")
                .font(.headline)
                .fontWeight(.bold)
//            TextField("post title", text: $viewModel.post.title)
            TextField("post title", text: $offlineTitle)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: offlineTitle.count)

//            CharactersRemainView(currentCount: viewModel.post.title.count)
            
            Divider()
        }
    }
    
    //MARK: Location Text

    private var locationTextField: some View {
        VStack(alignment: .leading) {
            Text("approximate location")
                .font(.headline)
                .fontWeight(.bold)
//            TextField("general location of photos", text: $viewModel.post.locationText)
            TextField("general location of photos", text: $offlineLocation)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundColor(.secondary)
            
            CharactersRemainView(currentCount: offlineLocation.count)

//            CharactersRemainView(currentCount: viewModel.post.locationText.count)
            
            Divider()
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

    
    
