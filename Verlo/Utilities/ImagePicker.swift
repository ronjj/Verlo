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
import Firebase

@MainActor
class ImagePicker: ObservableObject {
    
    @Published var image: Image?
    @Published var images: [Image] = []
    
    @Published var uiImage: UIImage?
    @Published var uiImages: [UIImage] = []
    
//    @Published var imageString: String = ""
    @ObservedObject var viewModel = FirebasePostViewModel()

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
}


