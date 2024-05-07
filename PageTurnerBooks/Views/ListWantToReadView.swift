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
                VStack(alignment: .leading) {
                    Text(book.volumeInfo.title)
                    Text(book.id) // Display the book ID as well to confirm the data is correct
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                print("Want to Read Books: \(viewModel.wantToReadBooks)")
            }
            
        }
        Button("Refresh") {
            viewModel.loadBooksFor(listType: .wantToRead)
        }
    }
}

