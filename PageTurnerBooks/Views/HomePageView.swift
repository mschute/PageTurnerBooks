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
    @EnvironmentObject var booksListViewModel: BooksListViewModel
    
    var body: some View {
        
        ZStack(alignment: .top){
            Image("SubtleBookPurple")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.1)
            
            VStack(spacing: 10){
                VStack(spacing: 10){
                    VStack(spacing: 30){
                        Text("Welcome")
                            .font(.largeTitle)
                            .padding(.top, 10)
                        if let fullName = authViewModel.currentUser?.fullName {
                            Text("\(fullName)")
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                            //TODO: Improve animation
                                .transition(.opacity)
                                .animation(.easeIn(duration: 0.5))
                        }
                    }
                    
                    Text("Continue reading...")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pTPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                  
                    NavigationStack{
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(Array(booksListViewModel.currentlyReadingBooks.prefix(4)), id: \.id) { book in
                                    VStack(alignment: .leading, spacing: 10){
                                        BookRow(book: book, viewModel: booksListViewModel)
                                        //TODO: Link to tracker
                                        Button("Track", action: {
                                            print("Tracker clicked")
                                        })
                                        .fontWeight(.bold)
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding()
                    .tint(.pTSecondary)
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
            .environmentObject(AuthViewModel.mock)
            .environmentObject(BookTrackerViewModel.mock)
            .environmentObject(BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2"))
    }
}

