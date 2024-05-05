//
//  ContentView.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 03/05/2024.
//

//
//  ContentView.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 03/05/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bookManager = BookManager()
    @State private var isShowingScanner = false
    @State private var isShowingSearchBar = false
    @State private var searchText = ""
    @State private var navigateToDetail = false
    @EnvironmentObject var authViewModel: AuthViewModel

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
                    SearchBarView(searchText: $searchText, coordinator: makeCoordinator())
                        .environmentObject(bookManager)
                }

                if bookManager.books.count == 1 {
                    // Automatically navigate to detail when one book is scanned
                    BookDetailView(bookItem: bookManager.books.first!)
                    // Ensure the scanner is closed when navigating to detail view
                    .onAppear {
                        isShowingScanner = false
                    }
                } else if bookManager.books.count > 1 {
                    List(bookManager.books) { book in
                        NavigationLink(destination: BookDetailView(bookItem: book)) {
                            Text(book.volumeInfo.title)
                        }
                    }
                }
            }
        }
                if authViewModel.isSignedIn {
                    AccountView()
                } else {
                    LandingPageView()
                }
    }

    private func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.delegate = bookManager
        return coordinator
    }
}
