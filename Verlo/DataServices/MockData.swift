//
//  MockData.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import Foundation

class PostsDataService {
//    static let posts: [Post] = [
//
//        Post(id: "1", title: "chill view at beebe", locationText: "beebe lake", longitude: 42.45134, lattitude: 76.47643, images: ["none"], dateEvent: Date()),
//        Post(id: "2", title: "view from bridge", locationText: "frosh bridge", longitude: 42.45201, lattitude: 76.48603, images: ["none"], dateEvent: Date()),
//        Post(id: "3", title: "dope view at the football game",locationText: "football field", longitude: 42.444172, lattitude: -76.478661, images: ["none"], dateEvent: Date()),
//        Post(id: "4", title: "this is a post with a super long title to see how the text wrapping works", locationText: "super long location name just to test length", longitude: 42.444172, lattitude: -76.478661, images: ["none"], dateEvent: Date())
//    ]
    
    static let posts: [Post] = [
        
        Post(id: "1", title: "chill view at beebe", locationText: "beebe lake", dateEvent: Date()),
        Post(id: "2", title: "view from bridge", locationText: "frosh bridge", dateEvent: Date()),
        Post(id: "3", title: "dope view at the football game",locationText: "football field",  dateEvent: Date()),
        Post(id: "4", title: "this is a post with a super long title to see how the text wrapping works", locationText: "super long location name just to test length", dateEvent: Date())
    ]
}
