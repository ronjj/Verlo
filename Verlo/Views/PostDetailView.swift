//
//  PostDetailView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI

struct PostDetailView: View {
   
    var post: Post
  
    var body: some View {
        Text("Detail view for \(post.title)")
    }
}

