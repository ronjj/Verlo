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
    
    @EnvironmentObject private var vm: PostViewModel
    @AppStorage("log_status") var logStatus: Bool = false
    
    let columns: [GridItem] = [GridItem(), GridItem()]
    @ObservedObject var viewModel = FirebasePostViewModel()
    
    let user = Auth.auth().currentUser?.email ?? "user"
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.verloGreen
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    emailAndSignOut
                    myPostsView
                    toVisitPostsView
                        .padding(.vertical)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                        profileText
                }
            }
        }
    }
}

extension ProfileView {
    
    private var profileText: some View {
        VStack(alignment: .leading){
            Text("profile view")
                .font(.title)
                .fontWeight(.black)
        }
    }
    
    private var emailAndSignOut: some View {
        HStack {
            signedInAsText
            Spacer()
            signOutButton
        }
        .padding(.horizontal)
    }
    
    private var signedInAsText: some View {
        HStack{
            Image(systemName: "envelope.fill")
                .font(.subheadline)
                .fontWeight(.bold)
//            +
            Text(user)
                .font(.subheadline)
        }
    }
    
    private var signOutButton: some View {
        Button {
            try? Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            withAnimation(.easeInOut) {
                logStatus = false
            }
        } label: {
            Text("sign out")
                .fontWeight(.bold)
                .foregroundColor(.verloGreen)
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)
    }
    
    private var toVisitPostsView: some View {
        VStack {
            VStack(spacing: 3){
                Text("to visit")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .padding(.horizontal)
                
                Rectangle()
                    .frame(width: 60, height: 2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .padding(.horizontal)
            }

            
            LazyVGrid(columns: columns) {
                ForEach(vm.toVisitPosts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        PostListRowView(post: post, imagesToDisplay: $viewModel.imagesToDisplay)
                        
                        //removes the blue highlight from SwiftUI NavigationLink
                            .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var myPostsView: some View {
        VStack {
            VStack(spacing: 3){
                Text("my posts")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .padding(.horizontal)
                
                Rectangle()
                    .frame(width: 75, height: 2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .padding(.horizontal)

            }
            
            
            LazyVGrid(columns: columns) {
                ForEach(vm.myPosts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        PostListRowView(post: post, imagesToDisplay: $viewModel.imagesToDisplay)
                        
                        //removes the blue highlight from SwiftUI NavigationLink
                            .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
