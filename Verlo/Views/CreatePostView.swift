//
//  CreatePostView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI

struct CreatePostView: View {
    var body: some View {
        
        VStack{
            Image(systemName: "plus")
            Text("Create a Post Screen")
                .font(.largeTitle)
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
