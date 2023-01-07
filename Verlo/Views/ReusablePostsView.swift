//
//  ReusablePostsView.swift
//  TwitterClone
//
//  Created by Ronald Jabouin on 1/3/23.
//

import SwiftUI
import Firebase

struct ReusablePostsView: View {
    
    var basedonUID: Bool = false
    var uid: String = ""
    
    @Binding var posts: [Post]
    
    @State var isFetching: Bool = true
    
    //Pagination
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            
            //disable refresh for UID based Post's
            guard !basedonUID else {return}
            
            isFetching = true
            posts = []
            //resetting pagination doc
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else{return}
            await fetchPosts()
        }
    }
    
    @ViewBuilder
    func Posts()->some View {
        ForEach(posts) { post in
            PostCardView(post: post) { updatedPost in
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }) {
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll{post.id == $0.id}
                }
            }
            .onAppear {
                //when last post appears, fetch new post if available
                if post.id == posts.last?.id && paginationDoc != nil {
                    Task{await fetchPosts()}
                }
            }
            
            Divider()
                .padding(.horizontal, -15)
        }
    }
    
    func fetchPosts()async {
        do {
            var query: Query!
            
            if let paginationDoc {
                
                query = Firestore.firestore().collection("Posts")
                    .order(by:"publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by:"publishedDate", descending: true)
                    .limit(to: 20)
            }

            //New query for UID based document fetch
            //filtering the posts which does not belong to the UID
            if basedonUID {
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                //saving the last doc for pagination
                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

