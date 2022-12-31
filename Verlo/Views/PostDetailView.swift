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
    
    @FirestoreQuery(collectionPath: "posts") var posts: [Post]

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
                //TODO: Add sheet for mapDetailSelected
            }
            
        }
        .sheet(isPresented: $mapDetailSelected) {
            MapDetailView(post: post, mapDetailSelected: $mapDetailSelected)
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
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: post.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))), annotationItems: posts) { post in
                MapMarker(coordinate: post.coordinates)
            }
                .aspectRatio(1, contentMode: .fit)
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

struct MapDetailView: View {
    
    var post: Post
    
    @Binding var mapDetailSelected: Bool
    @State private var coordinates = CLLocationCoordinate2D(latitude: 42.449317, longitude: -76.484366)
    @State private var mapSpan = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
    
    var body: some View {
        VStack {
            DetailedMapView(centerCoordinate: $coordinates, span: $mapSpan)
                .overlay(alignment: .topTrailing) {
                    Button {
                        mapDetailSelected.toggle()
                    } label : {
                        Text("close")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding()
                }
        }
        .onAppear {
            coordinates.longitude = post.longitude
            coordinates.latitude = post.lattitude
        }
    }
}



