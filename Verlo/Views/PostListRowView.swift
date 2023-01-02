//
//  PostListRowView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI

struct PostListRowView: View {
    
    var post: Post
    
    @Binding var imagesToDisplay: [UIImage]
    @ObservedObject var viewModel = FirebasePostViewModel()
    
    @EnvironmentObject private var vm: PostViewModel
    
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
    }
}

extension PostListRowView {
    
    private var imagesView: some View {
        TabView {
            ForEach(post.pictures, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
            }
        }
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
