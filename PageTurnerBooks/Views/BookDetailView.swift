//
// BookDetailView.swift

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BooksListViewModel 
    let bookItem: BookItem

    var body: some View {
        BookDetailComponent(viewModel: viewModel, bookItem: bookItem)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2") // Initialize your view model here
        let book = BookItem(id: "1", volumeInfo: VolumeInfo(title: "Sample Book", subtitle: "Subtitle sample book", authors: ["Author1", "Author2"], publishedDate: "1984", pageCount: 346, language: "en", description: "There once was a boy, ok. This is boring, fuck this. Just read the fucking description. That's all you need, this book is a piece of shit. Be happy that you didn't waste your time any more than you should have. There we go. You have it. Now just fuck off.", imageLinks: nil, categories: ["Cuck fantasy"]))
        return BookDetailView(viewModel: viewModel, bookItem: book)
    }
}

