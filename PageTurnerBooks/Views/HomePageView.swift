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
        NavigationStack{
            VStack(spacing: 10){
                VStack(spacing: 30){
                    Image("SubtleBook")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    //.padding(.bottom, 20)
                    Divider()

                    //TODO: Improve animation (needed to stop placeholder name loading before fullName)
                    if let fullName = authViewModel.currentUser?.fullName {
                            Text("Welcome, \(fullName)")
                            .font(.largeTitle)
                            .padding()
                            .transition(.opacity)  // Apply a fade transition
                            .animation(.easeIn(duration: 0.5))
                        }

                    Text("You're currently reading...")
                        .font(.system(size: 25, weight: .semibold))
                    // Display currently reading books in a scrollable list
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack {
                                                ForEach(booksListViewModel.currentlyReadingBooks) { book in
                                                    NavigationLink(destination: TrackerView(viewModel: BookTrackerViewModel(userId: authViewModel.currentUser?.id ?? "", tracker: BookTrackerModel(id: book.id, userId: authViewModel.currentUser?.id ?? "", startDate: Date(), endDate: nil, lastPageRead: 0, totalPageCount: book.volumeInfo.pageCount ?? 0, bookTitle: book.volumeInfo.title)), listViewModel: booksListViewModel)) {
                                                        VStack {
                                                            Text(book.volumeInfo.title)
                                                                .foregroundColor(.primary)
                                                            Text("Tap to track progress")
                                                                .font(.caption)
                                                                .foregroundColor(.secondary)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: 200)
                                        
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

