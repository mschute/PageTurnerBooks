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
            Text("Books Wanted (\(viewModel.wantToReadBooks.count) books)")
                .font(.title)
                .padding()
            List(viewModel.wantToReadBooks, id: \.id) { book in
                HStack {
                    VStack(alignment: .leading) {
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
