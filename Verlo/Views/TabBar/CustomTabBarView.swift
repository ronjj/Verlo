//
//  CustomTabBarView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/11/22.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    
    var body: some View {
       tabBarVersion2
            .onChange(of: selection, perform: { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            })
    }
}

extension CustomTabBarView {

    private func switchToTab(tab: TabBarItem) {
            selection = tab
            
        
    }
    
    private var tabBarVersion2: some View {
        HStack{
            ForEach(tabs, id: \.self) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
            
        }
        .cornerRadius(10)
        .background(.thickMaterial).ignoresSafeArea(edges: .bottom)
        .padding(6)
//        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .cornerRadius(10)
    }
}

extension CustomTabBarView {
    func tabView2(tab: TabBarItem) -> some View {
        VStack{
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.subheadline)
        }
        .cornerRadius(10)
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        
        .background(
            ZStack{
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
}

