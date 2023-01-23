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
    @Published var toVisitPosts: [Post]

    init() {
        let posts = PostsDataService.posts
        self.posts = posts
        
        let myPosts = PostsDataService.myPosts
        self.myPosts = myPosts
        
        let toVisitPosts = PostsDataService.toVisitPosts
        self.toVisitPosts = toVisitPosts
    }


}
