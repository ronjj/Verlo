//
//  ContentView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/7/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct HomeView: View {
    
    //Env object for using dummy data
    @EnvironmentObject private var vm: PostViewModel
    
    @State private var isAddingView = false
    @FirestoreQuery(collectionPath: "posts") var posts: [Post]
    
    @ObservedObject var viewModel = FirebasePostViewModel()
    
    let columns: [GridItem] = [GridItem(), GridItem()]
    

    var body: some View {
        NavigationView{
            ZStack{
                Color.verloGreen
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    listView
                        .padding(.vertical)
                }
                .scrollIndicators(.hidden)
            }
            
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
        LazyVGrid(columns: columns) {
            ForEach(vm.posts) { post in
                NavigationLink(destination: PostDetailView(post: post)) {
                    PostListRowView(post: post, imagesToDisplay: $viewModel.imagesToDisplay)
                    
                
                //                    removes the blue highlight from SwiftUI NavigationLink
                .buttonStyle(.plain)
            }
        }
    }

//        LazyVStack{
//            ForEach(vm.posts) { post in
//                Grid {
//                    GridRow {
//                        ForEach(0..<2) {_ in
//                            NavigationLink(destination: PostDetailView(post: post)) {
//                                PostListRowView(post: post, imagesToDisplay: $viewModel.imagesToDisplay)
//
//                            }
//                            //                    removes the blue highlight from SwiftUI NavigationLink
//                            .buttonStyle(.plain)
//                        }
//                    }
//                }
//            }
//        }
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
