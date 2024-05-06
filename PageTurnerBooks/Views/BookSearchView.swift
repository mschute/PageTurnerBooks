//
//  BookSearchView.swift
//  PageTurnerBooks
//
//  Created by Staff on 06/05/2024.
//

import SwiftUI

struct BookSearchView: View {
    @EnvironmentObject private var bookManager: BookManager
    @EnvironmentObject private var viewModel: BooksListViewModel
    
    @State private var isShowingScanner = false
    @State private var isShowingSearchBar = false
    @State private var searchText = ""
    @State private var navigateToDetail = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Start Scanning") {
                    isShowingScanner = true
                }
                .sheet(isPresented: $isShowingScanner) {
                    BarcodeScannerView(isShowingScanner: $isShowingScanner, coordinator: makeCoordinator())
                }

                Button("Search Books") {
                    isShowingSearchBar = true
                }
                .sheet(isPresented: $isShowingSearchBar) {
                    SearchBarView(searchText: $searchText, viewModel: viewModel, coordinator: makeCoordinator())
                        .environmentObject(bookManager)
                }

                if bookManager.books.count == 1 {
                    NavigationLink(destination: BookDetailView(viewModel: viewModel, bookItem: bookManager.books.first!), isActive: $navigateToDetail) {
                        EmptyView()
                        }
                        .onAppear {
                            navigateToDetail = true
                            isShowingScanner = false  // Ensure the scanner is closed when navigating to detail view
                        }
                }
            }
        }
    }
    private func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.delegate = bookManager
        return coordinator
    }
}

struct BookSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let bookManager = BookManager.shared
        let booksListViewModel = BooksListViewModel(userId: "previewUserId")
        
        return BookSearchView()
            .environmentObject(bookManager)
            .environmentObject(booksListViewModel)  // Adding BooksListViewModel to the environment
    }
}
