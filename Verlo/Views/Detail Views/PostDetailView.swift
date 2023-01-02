//
//  PostDetailView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct PostDetailView: View {
    
    var post: Post
    
    @State var likeTapped: Bool = false
    @State var mapDetailSelected: Bool = false
    
    @ObservedObject var viewModel = FirebasePostViewModel()
    @EnvironmentObject private var vm: PostViewModel

    @FirestoreQuery(collectionPath: "posts") var posts: [Post]
    
    var body: some View {
        ZStack {
            Color.verloGreen
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    imagesView
                        .tabViewStyle(PageTabViewStyle())
                        .frame(maxWidth: .infinity)
                        .frame(height: 500)
                        .edgesIgnoringSafeArea(.horizontal)
                    
                    postInfo
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    mapSection
                    
                }
                .navigationTitle(post.title)
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .sheet(isPresented: $mapDetailSelected) {
            MapDetailView(post: post, mapDetailSelected: $mapDetailSelected)
        }
    }
}

extension PostDetailView {
    
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
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "mappin")
                    .font(.body)
                Text(post.locationText.lowercased())
                    .font(.headline)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.trailing)
                
            }
            Text(post.fullDateAndTimeString.lowercased())
                .font(.subheadline)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth:.infinity, alignment: .leading)
    }
    
    
    private var mapSection: some View {
        VStack{
            HStack{
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
                
                Spacer()
            }
            .padding(.horizontal)
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: post.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))), annotationItems: [post]) { post in
                MapMarker(coordinate: post.coordinates)
            }
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture {
                mapDetailSelected.toggle()
            }
            .cornerRadius(30)
            .padding(.horizontal)
            .overlay(alignment: .topTrailing) {
            
                    mapDetailViewButton
                        .offset(x: -10)
                
            }
        }
    }
    
    private var mapDetailViewButton: some View {
        Button {
            mapDetailSelected.toggle()
        } label: {
            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
                .rotationEffect(Angle(degrees: 270))
        }
    }
}





