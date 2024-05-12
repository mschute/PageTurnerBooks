//
//  HomePageView.swift

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var bookTrackerViewModel: BookTrackerViewModel
    @EnvironmentObject var booksListViewModel: BooksListViewModel
    @State private var selectedBook: BookItem?
    @State private var isTrackingNavigationActive = false
    
    var body: some View {
        
        ZStack(alignment: .top){
            Image("SubtleBookPurple")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.1)
            
            VStack(spacing: 10){
                VStack(spacing: 10){
                    VStack(spacing: 20){
                        Text("Welcome")
                            .font(.largeTitle)
                            .padding(.top, 10)
                                if let fullName = authViewModel.currentUser?.fullName {
                                    Text(fullName)
                                        .font(.system(size: 50))
                                        .fontWeight(.bold)
                                        .padding(.top, 20)
                                        .transition(.opacity)
                                } else {
                                    Text("Loading name...")
                                        .font(.system(size: 50))
                                        .fontWeight(.bold)
                                        .padding(.top, 20)
                                        .foregroundColor(.clear)                                                }
                            }

                    
                    Text("You are currently reading...")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pTPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 37)
                    //Spacer()
                                        
                    List(booksListViewModel.currentlyReadingBooks, id: \.id) { book in
                        VStack{
                            BookRow(book: book, viewModel: booksListViewModel)
                            
                            HStack {
                                Text("View Tracking")
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .padding(9)
                                    .background(Color.pTSecondary)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.pTSecondary)
                                    )
                                    .onTapGesture {
                                        self.selectedBook = book
                                        DispatchQueue.main.async {
                                            self.isTrackingNavigationActive = true
                                        }
                                    }
                                
                                NavigationLink(destination: TrackerView(viewModel: BookTrackerViewModel(userId: booksListViewModel.userId, tracker: BookTrackerModel(id: book.id, userId: booksListViewModel.userId, startDate: Date(), endDate: nil, lastPageRead: 0, totalPageCount: book.volumeInfo.pageCount ?? 0, bookTitle: book.volumeInfo.title)), listViewModel: booksListViewModel), isActive: Binding(
                                    get: { self.selectedBook?.id == book.id && self.isTrackingNavigationActive },
                                    set: { isActive in
                                        if !isActive {
                                            self.isTrackingNavigationActive = false
                                        }
                                    }
                                )) {
                                    EmptyView()
                                }
                                .hidden()
                                
                                Spacer()
                                
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .tint(.ptSecondary)
                    .padding(.top, -10)
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
                .environmentObject(BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03"))
        }
    }
    
