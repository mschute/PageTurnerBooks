//
//  NavBar.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            SearchBooksView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            ListsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Lists")
                }
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .accentColor(.white)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    }
}

#Preview {
    NavBar()
}
