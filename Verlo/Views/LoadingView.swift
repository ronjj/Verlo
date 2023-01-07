//
//  LoadingView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 1/7/23.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            if show{
                Group {
                    Rectangle()
                        .fill(.black.opacity(0.25))
                    
                    ProgressView()
                        .padding(15)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
        
    }
}

