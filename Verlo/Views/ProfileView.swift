//
//  ProfileVIew.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            Image(systemName: "person")
            Text("Profile Screen")
                .font(.largeTitle)
        }
    }
}

struct ProfileVIew_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
