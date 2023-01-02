//
//  PostViewModel.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI

class PostViewModel: ObservableObject {

    @Published var posts: [Post]
    @Published var myPosts: [Post]
    @Published var likedPosts: [Post]

    init() {
        let posts = PostsDataService.posts
        self.posts = posts
        
        let myPosts = PostsDataService.myPosts
        self.myPosts = myPosts
        
        let likedPosts = PostsDataService.likedPosts
        self.likedPosts = likedPosts
    }


}
