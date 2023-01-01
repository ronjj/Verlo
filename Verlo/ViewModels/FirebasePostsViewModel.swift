//  Based on code from BookSpine by
//  Peter Friese on Github
//
//  FirebasePostViewModel.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/30/22.
//

import Foundation
import Combine
import FirebaseFirestore

class FirebasePostsViewModel: ObservableObject {
  @Published var posts = [Post]()
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("posts").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.posts = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Post.self)
        }
      }
    }
  }
  
  func removePosts(atOffsets indexSet: IndexSet) {
    let posts = indexSet.lazy.map { self.posts[$0] }
    posts.forEach { post in
      if let documentId = post.id {
        db.collection("posts").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }
}
