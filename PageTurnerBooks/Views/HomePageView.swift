//
//  HomePage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        ZStack{
            Color("BackgroundColor")
            VStack(spacing: 40){
                //Need to replace username with the user's email prefix
                Text("Welcome, {username}")
                    .font(.largeTitle)
                
                Text("You're currently reading...")
                    .font(.title3)
                //Need to add Book Previews / perhaps 1st or 2nd on the list?
                //Need to replace action in button to take user to tracking page for this book
                CustomButton(title: "Track", action: {print("Tracker was selected")})
                
                Text("Suggested titles...")
                    .font(.title3)
                //Need to add Book Previews randomly selected from data model? Could maybe get rid of this
                //Need to replace action in button to add this book to the Want to Read list
                CustomButton(title: "Want to read", action: {print("Tracker was selected")})
                
            }
        }
        .globalBackground()
        
    }
        
}

#Preview {
    HomePageView()
}

