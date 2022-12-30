//
//  PostViewModel.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI

class PostViewModel: ObservableObject {

//    @Published var posts: [Post]

    init() {
        let posts = PostsDataService.posts
//        self.posts = posts
    }


}
