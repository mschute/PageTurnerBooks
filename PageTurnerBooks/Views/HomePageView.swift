//
//  HomePage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var bookTrackerViewModel: BookTrackerViewModel
    @State private var isActiveTracker = false
    var body: some View {
        NavigationView{
            VStack(spacing: 10){
                VStack(spacing: 30){
                    //TODO: Need to replace username with the user's email prefix
                    Text("Welcome, {username}")
                        .font(.largeTitle)
                    Text("You're currently reading...")
                        .font(.title3)
                    //TODO: Need to add Book Previews / perhaps 1st or 2nd on the list?
                    //TODO: Need to replace action in button to take user to tracking page for this book
                    
                    PrimaryButton(title: "Track", action: {
                        print("trackerbutton is clicked")
                    })
                    Spacer()
                    
                    //TODO: What else should we add here? Maybe just our Logo?
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomePageView()
}

