//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 13/08/21.
//  From LocationPickerForSwiftUI on Github
//
//  Tweaked by Ronald Jabouin

import SwiftUI
import MapKit
import MobileCoreServices

public struct LocationPicker: View {
    
    // MARK: - View properties
    
    @Environment(\.presentationMode) var presentationMode
    
    let instructions: String
    @Binding var coordinates: CLLocationCoordinate2D
    @State private var defaultMapType: MKMapType = .standard
    @State private var switchMapType: Bool = false


    @State var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    @State private var alert = (false, "")
    let dismissOnSelection: Bool
    
    
    /// Initialize LocationPicker view
    /// - Parameters:
    ///   - instructions: label to display on screen
    ///   - coordinates: binding to latitude/longitude coordinates
    public init(instructions: String = "", coordinates: Binding<CLLocationCoordinate2D>, dismissOnSelection: Bool = false) {
        self.instructions = instructions
        self._coordinates = coordinates
        self.dismissOnSelection = dismissOnSelection
    }
    /// Initialize LocationPicker view
    /// - Parameters:
    ///   - instructions: localized key of the text to display on screen
    ///   - coordinates: binding to latitude/longitude coordinates
    ///   - dismissOnSelection: automatically dismiss the view when new coordinates are selected
    public init(instructions: LocalizedStringKey, coordinates: Binding<CLLocationCoordinate2D>, dismissOnSelection: Bool = false) {
        self.instructions = instructions.toString()
        self._coordinates = coordinates
        self.dismissOnSelection = dismissOnSelection
    }
    
    // MARK: - View body
    
    public var body: some View {
        ZStack {
            MapView(centerCoordinate: $coordinates, span: $span, defaultMapType: $defaultMapType, switchMapType: $switchMapType)
                .edgesIgnoringSafeArea(.vertical)
            
            VStack {
                
                if !instructions.isEmpty {
                    Text(self.instructions)
                        .padding()
                        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                        .cornerRadius(20))
                        .padding(.top, 10)
                }
                    
                Spacer()
                
                switchMapButton
                
                //MARK: Reset Coordintaes Button
                if coordinates.longitude != -76.484366 && coordinates.latitude != 42.449317 {
                    Button {
                        coordinates.longitude = -76.484366
                        coordinates.latitude = 42.449317
                    } label: {
                        Text("reset coordinates")
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)

                }
                
                //MARK: Code to see coordinates in the location picker
                Text("\(coordinates.latitude), \(coordinates.longitude)")
                    .padding()
                    .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial)).cornerRadius(20))
                    .onTapGesture {
                        UIPasteboard.general.setValue("\(coordinates.latitude), \(coordinates.longitude)", forPasteboardType: kUTTypePlainText as String)
                    }
            }
            .padding()
        }
    }
}

extension LocationPicker {
    private var switchMapButton: some View {
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
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            } else {
                Image(systemName: "pencil.and.outline")
                    .font(.title2)
                    .padding(16)
                    .foregroundColor(.primary)
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
        }
    }
}
