//
//  ContentView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/7/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: PostViewModel
    
    @State private var isAddingView = false
    
    var body: some View {
        NavigationView{
            ZStack{
                //Background Color
                Color.verloGreen
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    listView
                        .padding(.vertical)
                }
                .scrollIndicators(.hidden)
            }
            
            //Code to give 2 line tab bar in SwiftUI
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    verloAtLocationText
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    addPostButton
                }
            }
        }
        .fullScreenCover(isPresented: $isAddingView) {
            CreatePostView(isAddingView: $isAddingView)
        }
    }
}

extension HomeView {
    
    private var listView: some View {
        LazyVStack{
            ForEach(vm.posts) { post in
                NavigationLink(destination: PostDetailView(post: post)) {
                    PostListRowView(post: post)
                    
                }
                //removes the blue highlight from SwiftUI NavigationLink
                .buttonStyle(.plain)
            }
        }
    }
    
    private var verloAtLocationText: some View {
        HStack() {
            Text("verlo")
                .font(.title)
                .fontWeight(.black)
            
            //Eventually want this to be dynamic based on the
            //email the user signs up with.
            Text("@ cornell")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var addPostButton: some View {
        Button {
            //            activeSheet = .addPost
            isAddingView.toggle()
        } label : {
            ZStack{
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                
                Image(systemName: "plus")
                    .fontWeight(.bold)
                    .foregroundColor(.verloGreen)
                
            }
        }
    }
}
