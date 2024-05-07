//
//  ListFinishedReading.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct ListFinishedReadingView: View {
    @ObservedObject var viewModel: BooksListViewModel

    var body: some View {
        VStack {
            Text("Books Finished")
                .font(.title)
                .padding()
            List(viewModel.finishedReadingBooks, id: \.id) { book in
                HStack {
                    Text(book.volumeInfo.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        viewModel.deleteBookFromFirestore(bookId: book.id, listType: .finishedReading)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}



