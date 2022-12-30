//
//  PostDetailView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI
import MapKit

struct PostDetailView: View {
    
    var post: Post
    
    @State var likeTapped: Bool = false
    
    var body: some View {
        ZStack {
            Color.verloGreen
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    //Images
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .edgesIgnoringSafeArea(.all)
                    
                    postInfo
                        .padding(.horizontal, 5)
                        .padding(.bottom, 10)
                    
                    mapSection
                    
                }
                .navigationTitle(post.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

extension PostDetailView {
    
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
                Text(post.locationText)
                    .font(.headline)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.trailing)
                
            }
            Text(post.fullDateAndTimeString)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var leftSideTextInfo: some View {
        Text("\(post.title)")
            .font(.body)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.5)
    }
    
    private var mapSection: some View {
        VStack{
            HStack{
                Spacer()
                
                Button {
                    likeTapped.toggle()
                } label : {
                    Image(systemName: likeTapped ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                
                Button {
                    //Share location button
                } label : {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: post.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))))
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(30)
                .padding(.horizontal)
        }
    }
}
