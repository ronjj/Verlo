//
//  Post.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct Post: Identifiable, Hashable, Codable, Equatable {
    @DocumentID var id: String?
//    @ServerTimestamp var created: Date?
    var title: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    var userName: String
    var userUID: String
    var userProfileURL: URL
    var locationText: String
    var lattitude: Double
    var longitude: Double
//    var pictures: [String]
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
    }
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
    enum CodingKeys: CodingKey {
        case title
        case imageURL
        case imageReferenceID
        case likedIDs
        case dislikedIDs
        case userName
        case userUID
        case userProfileURL
        case locationText
        case lattitude
        case longitude
//        case pictures
        case coordinates
        case coordinates
        case dateEvent
    }
}


