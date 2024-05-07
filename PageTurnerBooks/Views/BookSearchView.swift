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
    @State private var isShowingDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Start Scanning") {
                    isShowingScanner = true
                }
                .sheet(isPresented: $isShowingScanner, onDismiss: checkForBooks) {
                    BarcodeScannerView(isShowingScanner: $isShowingScanner, coordinator: makeCoordinator())
                }

                Button("Search Books") {
                    isShowingSearchBar = true
                }
                .sheet(isPresented: $isShowingSearchBar) {
                    SearchBarView(searchText: $searchText, viewModel: viewModel, coordinator: makeCoordinator())
                        .environmentObject(bookManager)
                }

                .sheet(isPresented: $isShowingDetail) {
                    if let book = bookManager.books.first {
                        BookDetailView(viewModel: viewModel, bookItem: book)
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
    
    private func checkForBooks() {
        if bookManager.books.count == 1 {
            isShowingDetail = true
        }
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
