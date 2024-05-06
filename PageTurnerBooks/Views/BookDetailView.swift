import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BooksListViewModel  // Add ViewModel as an observed object
    let bookItem: BookItem

    var body: some View {
        BookDetailComponent(viewModel: viewModel, bookItem: bookItem)  // Pass the viewModel
    }
}
