//
//  Post.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI
import MapKit

struct Post: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
//   @DocumentID var id: String? replace uuid with this to setup with firebase
    var title: String
    var locationText: String
    var lattitude: Double
    var longitude: Double
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
    }
    var images: [String]
    var dateEvent: Date
           var dateString: String {
               let formatter = DateFormatter()
               formatter.dateFormat = "MM-dd-YY"
               return formatter.string(from: dateEvent)
           }
            var timeString: String {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                formatter.timeZone = NSTimeZone(name: "EDT") as TimeZone?
                return formatter.string(from: dateEvent)
            }

    init(id: String? = nil, title: String = "", locationText: String = "", longitude: Double = 0.0, lattitude: Double = 0, coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0), images: [String] = [""], dateEvent: Date) {
        self.id = id ?? ""
        self.title = title
        self.locationText = locationText
        self.lattitude = lattitude
        self.longitude = longitude
        self.images = images
        self.dateEvent = dateEvent
    }
}



//struct Recipe: Identifiable, Hashable, Codable {
//    var id = UUID().uuidString
//
//
////@DocumentID var id: String?
//var name: String
//var time: Int
//var steps: [String]
//var ingredients: [String: Bool]
//var type: String
//var image: String
//
//init(id: String? = nil, name: String = "test", time: Int = 0, steps: [String] = [], ingredients: [String : Bool] = [:], type: String="test", image: String = "test") {
//    self.id = id ?? ""
//  self.name = name
//  self.time = time
//  self.steps = steps
//  self.ingredients = ingredients
//  self.type = type
//  self.image = image
//}
//}
