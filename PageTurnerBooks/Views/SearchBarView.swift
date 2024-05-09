import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isShowingSearchBar: Bool  // Added this line
    @EnvironmentObject var bookManager: BookManager
    @ObservedObject var viewModel: BooksListViewModel
    var coordinator: Coordinator

    var body: some View {
        NavigationView {
            VStack {
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

                if !bookManager.books.isEmpty {
                    List(bookManager.books, id: \.id) { book in
                        BookRow(book: book, viewModel: viewModel)
                    }
                }
            }
            .navigationBarTitle("Search Books", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                isShowingSearchBar = false
            })
        }
    }
}
