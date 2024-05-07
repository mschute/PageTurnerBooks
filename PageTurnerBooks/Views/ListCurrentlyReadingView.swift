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
            Text("Currently Reading")
                .font(.largeTitle)
                .padding()

            List(viewModel.currentlyReadingBooks, id: \.id) { book in
                HStack {
                    Text(book.volumeInfo.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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

struct ListCurrentlyReadingView_Preview: PreviewProvider {
    static var previews: some View {
        ListCurrentlyReadingView(viewModel: BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2"))
    }
}
