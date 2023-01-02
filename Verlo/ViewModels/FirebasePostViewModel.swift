//  Based on code from BookSpine by
//  Peter Friese on Github
//
//  FirebasePostViewModel.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/30/22.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import PhotosUI

class FirebasePostViewModel: ObservableObject {
    
//    @ObservedObject var imagePicker = ImagePicker()
  // MARK: - Public properties
  
  @Published var post: Post
  @Published var modified = false
    
   //MARK: - ImagePicker
    @Published var image: Image?
    @Published var images: [Image] = []
    
    @Published var uiImage: UIImage?
    @Published var uiImages: [UIImage] = []
    
    @Published var imagesToDisplay = [UIImage]()
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }

    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            Task {
                if !imageSelections.isEmpty {
                    try await loadTransferable(from: imageSelections)
                        imageSelections = []
                }
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.image = Image(uiImage: uiImage)
                    self.uiImage = uiImage
                }
            }
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }

    func loadTransferable(from imageSelections: [PhotosPickerItem]) async throws {
        do {
            for imageSelection in imageSelections {
                if let data = try await imageSelection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                            self.images.append(Image(uiImage: uiImage))
                            self.uiImages.append(uiImage)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    
    
    func removePhoto(index: Int) {
        images.remove(at: index)
    }
  
  // MARK: - Internal properties
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Constructors
  
    init(post: Post = Post(title: "", locationText: "", lattitude: 0.0, longitude: 0.0, pictures: [], dateEvent: Date())) {
    self.post = post
    
    self.$post
      .dropFirst()
      .sink { [weak self] post in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  // MARK: - Firestore
  
  private var db = Firestore.firestore()
  
  private func addPost(_ post: Post) {
    do {
        //Add images to the post.pictures here 
//        func uploadPhotos() {

//            //Storage reference
        let storageRef = Storage.storage().reference()

            //Turning image into data
        var imageData: [Data] = []
        var imageReferences: [String] = []

        for picture in uiImages {
            var jpegPicture = picture.jpegData(compressionQuality: 0.8)
            imageData.append(jpegPicture!)
            print(imageData)
        }

            //For singular picture
    //        let imageData = uiImage?.jpegData(compressionQuality: 0.8)

            //Check that image data was converted
        guard !imageData.isEmpty else {
            return
        }

        for picture in imageData {
            //Specify file path and name
            let path = "images/\(UUID().uuidString).jpg"
            print("-----------------------")
            self.post.pictures.append("\(path)")
            print("appended \(path) to pictures")
            print("Pictures array: \(self.post.pictures) ")
            let fileRef = storageRef.child(path)

            let uploadTask = fileRef.putData(picture, metadata: nil) {
                metadata, error in

                if error == nil && metadata != nil {

                    //save a reference to the fiels in firestore db
                    let db = Firestore.firestore()
                    db.collection("images").document().setData(["url":path])
                    imageReferences.append(path)
                    self.post.pictures = imageReferences
//                    self.imageString = ("\(path)")
//                    viewModel.post.images.append("\(path)")

                }
            }
        }
//            print("pictures array once upload photos \n is done being called \(post.pictures) and \(post.title)")
//
////        }
    
        print(post.title)
        print("post array before LET \(self.post.pictures)")
        let _ = try db.collection("posts").addDocument(from: self.post)
    }
    catch {
      print(error)
    }
  }
    

    func retrieveImages() {
        //current way: retrieving all images
        //Need to: retrieve the images only for the specific post
        
        let db = Firestore.firestore()
        
        //Want to go to posts
        db.collection("images").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                
                //within posts want to get the pictures array and loop through that
                for doc in snapshot!.documents {
                    paths.append(doc["url"] as! String)
                }
                
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    
                    let fileRef = storageRef.child(path)
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            if let image = UIImage(data: data!) {
//                                DispatchQueue.main.async {
//                                    self.imagesToDisplay.append(image)
//
//                                }
                            }
                        }
                    }
                }
            }
        }
    }
  
  private func updatePost(_ post: Post) {
    if let documentId = post.id {
      do {
        try db.collection("posts").document(documentId).setData(from: post)
      }
      catch {
        print(error)
      }
    }
  }
  
    private func updateOrAddPost() {
    if let _ = post.id {
      self.updatePost(self.post)
    }
    else {
      addPost(post)

    }
  }
  
  private func removePost() {
    if let documentId = post.id {
      db.collection("posts").document(documentId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  // MARK: - UI handlers
  
  func handleDoneTapped() {
    self.updateOrAddPost()
  }
  
  func handleDeleteTapped() {
    self.removePost()
  }
  
}
