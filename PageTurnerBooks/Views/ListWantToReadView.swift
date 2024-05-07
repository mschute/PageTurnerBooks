//
//  ListWantToRead.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct ListWantToReadView: View {
    @ObservedObject var viewModel: BooksListViewModel

    var body: some View {
        VStack {
            Text("Want to Read 📕")
                .font(.largeTitle)
                .padding()
            Text("\(viewModel.wantToReadBooks.count) books")
                .font(.title2)
            List(viewModel.wantToReadBooks, id: \.id) { book in
                HStack {
                    VStack(alignment: .leading) {
                        //TODO: Need to replace this with a BookRow that then links to a BookDetail
                        Text(book.volumeInfo.title)
                        Text(book.id) // Display the book ID as well to confirm the data is correct
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        viewModel.deleteBookFromFirestore(bookId: book.id, listType: .wantToRead)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                viewModel.loadBooksFor(listType: .wantToRead)
            }
        }
        Button("Refresh") {
            viewModel.loadBooksFor(listType: .wantToRead)
        }
    }
}

struct ListWantToReadView_Preview: PreviewProvider {
    static var previews: some View {
        ListWantToReadView(viewModel: BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2"))
    }
}
