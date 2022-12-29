//
// Created for PHPicker Demo
// by Stewart Lynch on 2022-07-27
// Using Swift 5.0
//
// Tweaked and modified by Ronald Jabouin

import SwiftUI
import PhotosUI
import FirebaseStorage

@MainActor
class ImagePicker: ObservableObject {
    
    @Published var image: Image?
    @Published var images: [Image] = []
    
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
//                    imageSelections = []
                }
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.image = Image(uiImage: uiImage)
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
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func uploadPhotos() async throws {
//        //Create storage reference
//        let storageRef = Storage.storage().reference()
//
//        //TODO: Need to turn images into data
//        for image in images {
//            if let image = UIImage(data: image) {
//                print("...")
//            }
//        }
//
//        //Specifiy file path and name
//        //Might have issue because not all images are jpgs
//        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
//
//        //Upload the data
//        let uploadTask = fileRef.putData(images, metadata: nil) { metadata,
//            error in
//
//            if error == nil && metadata != nil {
//                //save a reference to the file in firestore DB
//            }
//        }
//
//        //Save a refernece to the file in Firestore DB
//    }
//
    func removePhoto(index: Int) {
        images.remove(at: index)
    }
}
