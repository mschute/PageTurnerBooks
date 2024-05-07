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
                Text(book.volumeInfo.title)
            }
        }
    }
}

