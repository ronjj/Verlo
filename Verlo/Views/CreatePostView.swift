//
//  CreatePostView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI

struct CreatePostView: View {
    
    @Binding var isAddingView: Bool
    @State private var exampleText1: String = ""
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Title")) {
                    TextField("Post Title", text: $exampleText1)

                }
                
                Section(header: Text("Photos")) {
                    

                }
            }
            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backArrowButton
                }
            }
        }
    }
}

extension CreatePostView {
    private var backArrowButton: some View {
        Button {
            isAddingView = false
        } label: {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                Image(systemName: "arrow.left")
                    .foregroundColor(.greenBG2)
            }
        }
    }
}
