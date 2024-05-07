//
//  ListCurrentlyReading.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct ListCurrentlyReadingView: View {
    @ObservedObject var viewModel: BooksListViewModel

    var body: some View {
        VStack {
            Text("Books Currently Being Read")
                .font(.title)
                .padding()

            List(viewModel.currentlyReadingBooks, id: \.id) { book in
                HStack {
                    Text(book.volumeInfo.title)
                        .frame(maxWidth: .infinity, alignment: .leading)  // Ensures the text takes up most of the space
                    
                    Button(action: {
                        viewModel.deleteBookFromFirestore(bookId: book.id, listType: .currentlyReading)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
