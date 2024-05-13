//
// SearchBarView.swift

import SwiftUI


struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isShowingSearchBar: Bool
    @EnvironmentObject var bookManager: BookManager
    @ObservedObject var viewModel: BooksListViewModel
    var coordinator: Coordinator
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .padding(.leading, 15)
                            .padding(.bottom, 6)
                    }
                    
                    Text("Search Books")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 3)
                        .padding(.bottom, 10)
                    
                    Spacer()
                        .frame(maxWidth: 35)
                }
                .background(Color.pTPrimary)
                .ignoresSafeArea(edges: .horizontal)
                .ignoresSafeArea(edges: .bottom)

                HStack {
                    TextField("Search", text: $searchText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Button(action: {
                        coordinator.searchBooks(searchText, source: .searchBar)
                        searchText = ""
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
                .padding()

                if bookManager.books.isEmpty {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List(bookManager.books, id: \.id) { book in
                        BookRow(book: book, viewModel: viewModel)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .tint(.pTPrimary)
    }
}
