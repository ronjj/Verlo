//
//  PostListRowView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI

struct PostListRowView: View {
    
    var post: Post
    
    var body: some View {
        VStack{
            Rectangle()
                //AsyncImage(post.images)
                    //.resizable()
                    //.aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.horizontal)
            HStack{
                Text("\(post.title)")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack{
                        Image(systemName: "mappin")
                            .font(.body)
                        Text(post.locationText)
                            .font(.headline)
                            .minimumScaleFactor(0.7)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    Text("posted \(post.dateString) @ \(post.timeString)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, 5)
            
        }
        .frame(maxWidth: .infinity, minHeight:  200, maxHeight: 300)
        .padding(.bottom, 5)
        
    }
}

