//
//  MapDetailView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/31/22.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct MapDetailView: View {
    
    var post: Post
    
    @Binding var mapDetailSelected: Bool
    
    @State private var coordinates = CLLocationCoordinate2D(latitude: 42.449317, longitude: -76.484366)
    @State private var mapSpan = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
    @State private var defaultMapType: MKMapType = .standard
    @State private var switchMapType: Bool = false
    
    var body: some View {
        VStack {
            DetailedMapView(centerCoordinate: $coordinates, span: $mapSpan, defaultMapType: $defaultMapType, switchMapType: $switchMapType)
                .overlay(alignment: .topTrailing) {
                    VStack{
                        Button {
                            mapDetailSelected.toggle()
                        } label : {
                            Text("close")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .padding()
                        
                        Button {
                            switchMapType.toggle()
                        
                            if switchMapType {
                                defaultMapType = .hybrid
                            }
                            
                            if !switchMapType{
                                defaultMapType = .standard
                            }
                        } label : {
                            if defaultMapType == .standard {
                                Image(systemName: "globe.americas")
                                    .font(.title2)
                                    .padding(16)
                                    .foregroundColor(.primary)
                                    .background(.thickMaterial)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    .padding()
                            } else {
                                Image(systemName: "pencil.and.outline")
                                    .font(.title2)
                                    .padding(16)
                                    .foregroundColor(.primary)
                                    .background(.thickMaterial)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    .padding()
                            }
                        }
                    }
                }
        }
        .onAppear {
            coordinates.longitude = post.longitude
            coordinates.latitude = post.lattitude
        }
    }
}
