//
//  PostListRowView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestoreSwift
import Firebase
import FirebaseStorage

struct PostCardView: View {
    
    
//    @Binding var imagesToDisplay: [UIImage]
    //    @ObservedObject var viewModel = FirebasePostViewModel()
    //
    //    @EnvironmentObject private var vm: PostViewModel
    
    var post: Post
    var onUpdate: (Post)->()
    var onDelete: ()->()
    
    @AppStorage("user_UID") var userUID: String = ""
    
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        VStack{
            imagesView
                .tabViewStyle(PageTabViewStyle())
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .edgesIgnoringSafeArea(.horizontal)
            
            postInfo
                .padding(.horizontal, 5)
        }
        //        PostInteraction()
        .onAppear {
            if docListener == nil {
                guard let postID = post.id else {return}
                docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot {
                        if snapshot.exists{
                            //Document updated
                            //Fetching updated document
                            if let updatedPost = try? snapshot.data(as: Post.self) {
                                onUpdate(updatedPost)
                            }
                        } else {
                            //Document Deleted
                            onDelete()
                        }
                    }
                    
                })
            }
        }
        .onDisappear {
            //Applying snapshot listener only when the post is available on the screen
            // Else remove the listener. saves unwanted live updates from the posts that were swiped
            //off screen
            
            if let docListener {
                docListener.remove()
                self.docListener = nil
            }
        }
    }
    
    @ViewBuilder
    func PostInteraction()->some View {
        HStack(spacing: 6) {
            Button {
                likePost()
            } label: {
                Image(systemName: post.likedIDs.contains(userUID) ? "hand.thumbsup.fill": "hand.thumbsup")
            }

            Text("\(post.likedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)

            Button {
                dislikePost()
            } label: {
                Image(systemName: post.dislikedIDs.contains(userUID) ? "hand.thumbsdown.fill": "hand.thumbsdown")
            }
            .padding(.leading, 25)

            Text("\(post.dislikedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.black)
        .padding(.vertical, 8)
    }
    
    func likePost() {
        Task {
            guard let postID = post.id else {return}
            
            //remove users uid from array if post has already recieved likes. if not add to the array
            if post.likedIDs.contains(userUID){
                
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likeIDs": FieldValue.arrayRemove([userUID])
                ])
            } else {
                
                //removing user id from the array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likeIDs": FieldValue.arrayUnion([userUID]),
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    
    func dislikePost() {
        Task {
            guard let postID = post.id else {return}
            
            //remove users uid from array if post has already recieved likes. if not add to the array
            if post.dislikedIDs.contains(userUID){
                
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            } else {
                
                //removing user id from the array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likeIDs": FieldValue.arrayRemove([userUID]),
                    "dislikedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    func deletePost() {
        Task {
            //delte image from Firebase storage if present
            do {
                if post.imageReferenceID != "" {
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                
                //delete firestore document
                guard let postID = post.id else {return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


extension PostCardView {
    
    private var imagesView: some View {
        //        TabView {
        //            ForEach(post.pictures, id: \.self) { image in
        //                Image(image)
        //                    .resizable()
        //                    .scaledToFill()
        //            }
        //        }
        WebImage(url: post.imageURL)
            .resizable()
            .scaledToFill()
    }
    
    private var postInfo: some View {
        VStack(alignment: .leading, spacing: 10){
            postTitle
            
            postLocationAndTime
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var postLocationAndTime: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "mappin")
                    .font(.caption)
                Text(post.locationText.lowercased())
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.trailing)
                
            }
            Text("posted \(post.dateString.lowercased()) @ \(post.timeString)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var postTitle: some View {
        Text("\(post.title.lowercased())")
            .font(.body)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.5)
    }
}
