//
//  Post.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct Post: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
//    @ServerTimestamp var created: Date?
    var title: String
    var locationText: String
    var lattitude: Double
    var longitude: Double
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
    }
//    var images: [String]
    var dateEvent: Date
           var dateString: String {
               let formatter = DateFormatter()
               formatter.dateFormat = "MMM d"
               return formatter.string(from: dateEvent)
           }
    
            var timeString: String {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                formatter.timeZone = NSTimeZone(name: "EDT") as TimeZone?
                return formatter.string(from: dateEvent)
            }
    
            var fullDateAndTimeString: String {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy @ h:mm a"
                formatter.timeZone = NSTimeZone(name: "EDT") as TimeZone?
                return formatter.string(from: dateEvent)
            }
}


