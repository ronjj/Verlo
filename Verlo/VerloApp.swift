//
//  VerloApp.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/7/22.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
@StateObject private var vm = PostViewModel()


  var body: some Scene {
    WindowGroup {
        AppTabBarView()
            .environmentObject(vm)    }
  }
}
