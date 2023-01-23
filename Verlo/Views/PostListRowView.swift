//
//  PostListRowView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/10/22.
//

import SwiftUI

struct PostListRowView: View {
    
    var post: Post


    @Binding var imagesToDisplay: [UIImage]
    @ObservedObject var viewModel = FirebasePostViewModel()
    
    @EnvironmentObject private var vm: PostViewModel
    
    var body: some View {
        VStack{
            imagesView
                .tabViewStyle(PageTabViewStyle())
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .edgesIgnoringSafeArea(.horizontal)
            
            postInfo
                .padding(.horizontal, 5)
        }
    }
}

extension PostListRowView {
    
    private var imagesView: some View {
        TabView {
            ForEach(post.pictures, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
            }
        }
    }
    
    private var postInfo: some View {
        VStack(alignment: .leading, spacing: 10){
            postTitle
            
            postLocationAndTime
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var postLocationAndTime: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "mappin")
                    .font(.caption)
                Spacer()
                    .frame(width: -10)
                Text(post.locationText.lowercased())
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.trailing)
                
            }
//            Text("posted \(post.dateString.lowercased()) @ \(post.timeString)")
            Text("\(post.dateEvent.timeAgoDisplay())")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var postTitle: some View {
        Text("\(post.title.lowercased())")
            .font(.body)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.5)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        //Seconds Ago
        if secondsAgo < minute {
            if secondsAgo == 1 {
                return "\(secondsAgo) second ago"
            } else {
                return "\(secondsAgo) seconds ago"
            }
            
        //Minutes Ago
        } else if secondsAgo < hour {
            if secondsAgo / minute == 1 {
                return "\(secondsAgo / minute) minute ago"
            } else {
                return "\(secondsAgo / minute) minutes ago"
            }
            
      //Hours Ago
        } else if secondsAgo < day {
            if secondsAgo / hour == 1 {
                return "\(secondsAgo / hour) hour ago"
            } else {
                return "\(secondsAgo / hour) hours ago"
            }
        
        //Days Ago
        } else if secondsAgo < week {
            if secondsAgo / day == 1 {
                return "\(secondsAgo / day) day ago"
            } else {
                return "\(secondsAgo / day) days ago"
            }
        }
        
        //Weeks Ago
        return "\(secondsAgo / week) weeks ago"
    }
}
