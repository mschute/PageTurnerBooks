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
    
    //TODO: Delete later, this is sample data to get the nav to work
    let bookTrackerData = BookTrackerViewModel(tracker: BookTrackerModel(startDate: Date(), endDate: Date(), lastPageRead: 100, totalPageCount: 300, bookTitle: "Harry Potter and the Scorcerers Stone"))
    
    var body: some View {
        NavigationView{
            VStack(spacing: 10){
                VStack(spacing: 30){
                    //TODO: Need to replace username with the user's email prefix
                    Text("Welcome, {username}")
                        .font(.largeTitle)
                        .padding()
                    //TODO: What else should we add here? Maybe just our Logo?
                    Text("You're currently reading...")
                        .font(.title2)
                    //TODO: Need to add Book Previews / perhaps 1st or 2nd on the list?
                    //TODO: Need to replace action in button to take user to tracking page for this book
                    
                    NavigationLink(destination: TrackerView(viewModel: bookTrackerData)) {
                        Text("Tracker")
                        
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    Spacer()
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomePageView()
}

