
//  MapView.swift
//
//
//  Created by Alessio Rubicini on 13/08/21.
//  From LocationPickerForSwiftUI on Github
//  Forked version of MapView.swift from milkypailes on Github
//  Tweaked by Ronald Jabouin

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var span: MKCoordinateSpan

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.centerCoordinate = self.centerCoordinate
        mapView.region.span = self.span
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)

        view.removeAnnotations(view.annotations)
        view.addAnnotation(annotation)
        
        view.centerCoordinate = self.centerCoordinate
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            
            // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)

            withAnimation {
                let clObject = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                parent.centerCoordinate = clObject
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = clObject
                
                
                withAnimation {
                    parent.mapView.removeAnnotations(parent.mapView.annotations)
                    parent.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

struct DetailedMapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var span: MKCoordinateSpan

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        //MARK: Coordinates and Span
        mapView.centerCoordinate = self.centerCoordinate
        mapView.region.span = self.span
        
        //MARK: Show Compass
        mapView.showsCompass = false // hides current compass, which shows only on map turning
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: 20, y: 40) // you may use GeometryReader to replace it's position
        compassBtn.compassVisibility = .visible // compass will always be on map
        mapView.addSubview(compassBtn)
        
        //MARK: Show Scale
        mapView.showsScale = true
        
        

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.centerCoordinate = self.centerCoordinate

    }
}

