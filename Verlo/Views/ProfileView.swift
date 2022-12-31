//
//  ProfileVIew.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI
import Firebase
import GoogleSignIn


struct ProfileView: View {
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        
        //1. fetch list of saved posts
        
        //2. load saved posts in the same way the home view posts are
        
        VStack{
            Image(systemName: "person")
            Text("Profile Screen")
                .font(.largeTitle)
            Button {
                try? Auth.auth().signOut()
                GIDSignIn.sharedInstance.signOut()
                withAnimation(.easeInOut) {
                    logStatus = false
                }
            } label: {
                Text("Sign Out")
            }
        }
    }
}

