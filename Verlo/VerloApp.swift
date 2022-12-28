//
//  VerloApp.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/7/22.
//

import SwiftUI

@main
struct VerloApp: App {
    
    @StateObject private var vm = PostViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppTabBarView()
                .environmentObject(vm)
        }
    }
}
