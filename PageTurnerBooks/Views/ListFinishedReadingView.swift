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
            Text("Finished Reading")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pTPrimary)
                .padding(.top, 50)
                .ignoresSafeArea()
            List(viewModel.finishedReadingBooks, id: \.id) { book in
                HStack {
                    VStack{
                        //TODO: Need to replace this with a BookRow that then links to a BookDetail
                        Text(book.volumeInfo.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
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

struct ListFinishedReadingView_Preview: PreviewProvider {
    static var previews: some View {
        ListFinishedReadingView(viewModel: BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2"))
    }
}

