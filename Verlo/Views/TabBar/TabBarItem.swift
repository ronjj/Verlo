//
//  TabBarItem.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI


enum TabBarItem: Hashable {
    case home
    case create
    case profile
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .create: return "plus"
        case .profile: return "person"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .create: return "Create"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return  Color.greenBG3
        case .create: return Color.greenBG3
        case .profile: return Color.greenBG3
        }
    }
}
