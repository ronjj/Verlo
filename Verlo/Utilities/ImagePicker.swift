//
// Created for PHPicker Demo
// by Stewart Lynch on 2022-07-27
// Using Swift 5.0
//
// Tweaked and modified by Ronald Jabouin

import SwiftUI
import UIKit
import PhotosUI
import FirebaseStorage

@MainActor
class ImagePicker: ObservableObject {

    @Published var image: Image?
    @Published var images: [Image] = []
    
    @Published var uiImage: UIImage?
    @Published var uiImages: [UIImage] = []

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

    func uploadPhotos() {

        //Storage reference
        let storageRef = Storage.storage().reference()
        
        //Turning image into data
        var imageData: [Data] = []
                
        for picture in uiImages {
            var jpegPicture = picture.jpegData(compressionQuality: 0.8)
            imageData.append(jpegPicture!)
        }
        
        //For singular picture
//        let imageData = uiImage?.jpegData(compressionQuality: 0.8)
        
        //Check that image data was converted
        guard !imageData.isEmpty else {
            return
        }
        
        for picture in imageData {
            //Specify file path and name
            let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
            
            let uploadTask = fileRef.putData(picture, metadata: nil) {
                metadata, error in
                
                if error == nil && metadata != nil {
                    
                }
            }
        }
    }

    func removePhoto(index: Int) {
        images.remove(at: index)
    }
}


