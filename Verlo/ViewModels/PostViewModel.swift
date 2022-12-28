//
//  PostViewModel.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import Foundation


class PostViewModel: ObservableObject {
    
    @Published var posts: [Post]
    
    init() {
        let posts = PostsDataService.posts
        self.posts = posts
    }
}
