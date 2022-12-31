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

class FirebasePostViewModel: ObservableObject {
    
    @ObservedObject var imagePicker = ImagePicker()
  // MARK: - Public properties
  
  @Published var post: Post
  @Published var modified = false
  
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
      let _ = try db.collection("posts").addDocument(from: post)
    }
    catch {
      print(error)
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
