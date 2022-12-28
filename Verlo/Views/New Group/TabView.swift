//
//  TabView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
//        CustomTabBarContainerView(selection: $tabSelection) {
//            HomeView()
//                .tabBarItem(tab: .home, selection: $tabSelection)
//
//            CreatePostView()
//                .tabBarItem(tab: .create, selection: $tabSelection)
//
//            ProfileView()
//                .tabBarItem(tab: .profile, selection: $tabSelection)
//        }
        
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("House")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

