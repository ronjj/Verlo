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
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: post.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(30)
            Text(post.fullDateAndTimeString)
            
//            Text("Detail view for \(post.title)")
//            Text("selected coordinates \(post.lattitude) and \(post.longitude)")
//            Text("coorindates together are \(post.coordinates)")
        }
    }
}

