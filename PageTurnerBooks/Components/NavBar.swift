//
//  NavBar.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import SwiftUI

struct NavBar: View {
    private var selectedTab = 4
    var body: some View {
        TabView {
            Group{
                NavigationStack{
                    HomePageView()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
                
                NavigationStack{
                    BookSearchView().environmentObject(BookManager.shared)
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(2)
                
                NavigationStack{
                    ListsView()
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Lists")
                }
                .tag(3)
                
                NavigationStack{
                    AccountView()
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(4)
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .toolbarBackground(Color(.black), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)

    }
}

#Preview {
    NavBar().environmentObject(BookManager.shared)
}
