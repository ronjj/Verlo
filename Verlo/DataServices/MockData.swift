//
//  MockData.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import Foundation

class PostsDataService {
    
        static let posts: [Post] = [
    
            Post(id: "1", title: "chill views at beebe", locationText: "beebe lake", lattitude: 42.452299, longitude: -76.479995, pictures: ["beebe-lake1","beebe-lake2","beebe-lake3"], dateEvent: Date()),
            
            Post(id: "2", title: "view from bridge", locationText: "frosh bridge", lattitude: 42.451608, longitude: -76.481623, pictures: ["frosh-bridge"],dateEvent: Date()),
           
            Post(id: "3", title: "pink sunset",locationText: "arts quad", lattitude: 42.449665, longitude: -76.483518, pictures: ["pink-sunset"], dateEvent: Date()),
            
            Post(id: "4", title: "tuff reflections", locationText: "casc creek", lattitude: 42.45167, longitude: -76.51000, pictures: ["casc-creek"], dateEvent: Date()),
            
            Post(id: "5", title: "donlon kinda fire 🔥", locationText: "donlon", lattitude: 42.454964, longitude: -76.478088, pictures: ["donlon-1","donlon-2"], dateEvent: Date())
        ]

}
