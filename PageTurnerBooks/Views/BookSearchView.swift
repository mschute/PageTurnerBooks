//
//  BookSearchView.swift

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
            ScrollView{
                VStack {
                    Button(action: {
                        isShowingSearchBar = true
                    }) {
                        Image("searchIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 220)
                            .overlay(Rectangle().foregroundColor(Color.black.opacity(0.4)))
                            .overlay(Text("Search Books")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white))
                            .cornerRadius(10)
                    }
                    .fullScreenCover(isPresented: $isShowingSearchBar) {
                        SearchBarView(searchText: $searchText, isShowingSearchBar: $isShowingSearchBar, viewModel: viewModel, coordinator: makeCoordinator())
                            .environmentObject(bookManager)
                    }
                    .padding(.bottom, 50)
                    
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Image("scanIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 220)
                            .overlay(Rectangle().foregroundColor(Color.black.opacity(0.4)))
                            .overlay(Text("Scan Barcode")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white))
                            .cornerRadius(10)
                    }
                    .fullScreenCover(isPresented: $isShowingScanner, onDismiss: checkForBooks) {
                        BarcodeScannerView(isShowingScanner: $isShowingScanner, coordinator: makeCoordinator())
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)
            }
        }
        .tint(.ptPrimary)
    }
    
    private func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.delegate = bookManager
        coordinator.onBookRetrieved = {
            self.isShowingScanner = false
            self.isShowingSearchBar = true
        }
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
            .environmentObject(booksListViewModel)
    }
}

