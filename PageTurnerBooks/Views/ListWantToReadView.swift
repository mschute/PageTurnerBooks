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
            Text("Books Wanted")
                .font(.title)
                .padding()
            List(viewModel.wantToReadBooks, id: \.id) { book in
                Text(book.volumeInfo.title)
            }
        }
    }
}

struct ListWantToReadView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a dummy userId when initializing the ViewModel for previews
        ListWantToReadView(viewModel: BooksListViewModel(userId: "dummyUserId"))
    }
}
