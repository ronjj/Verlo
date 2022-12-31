//
//  ContentView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/30/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
   
    @AppStorage("log_status") var logStatus: Bool = false


    var body: some View {
        
        if logStatus {
            AppTabBarView()
        } else {
            LoginView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
