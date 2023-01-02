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
            TabView {
                ForEach(post.pictures, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
//                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle())

            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .edgesIgnoringSafeArea(.horizontal)
            
            postInfo
           
            .padding(.horizontal, 5)
            
        }

//        .onAppear {
//            viewModel.retrieveImages()
//        }
    }
}

extension PostListRowView {
    
    //Need to add tabbar for scrolling effect
    private var imagesView: some View {
//        Image(post.images.first ?? "google-icon")
        Text("placeholder for viewbuilder compiler erro")
    }
    
    private var postInfo: some View {
        HStack{
            leftSideTextInfo
            
            Spacer()
            
            rightSideTextInfo
        }
    }
    private var rightSideTextInfo: some View {
        VStack(alignment: .trailing) {
            HStack{
                Image(systemName: "mappin")
                    .font(.body)
                Text(post.locationText.lowercased())
                    .font(.headline)
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
    
    private var leftSideTextInfo: some View {
        Text("\(post.title.lowercased())")
            .font(.body)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.5)
    }
}
