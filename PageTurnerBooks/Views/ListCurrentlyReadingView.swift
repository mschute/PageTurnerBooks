//
//  ListCurrentlyReading.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct ListCurrentlyReadingView: View {
    @ObservedObject var viewModel: BooksListViewModel
    
    //TODO: Need to add tracker
    //TODO: Need to combine the trash and tracker buttons into the bookrow somehow
    //TODO: Need to change the chevron to white
    //TODO: Hard time getting the frame for list title on ListsView to be have less height, consider increasing the size of these so it matches and is less obvious its different
    //TODO: Reduce the white space

    var body: some View {
        VStack(spacing: 0) {
            Text("Currently Reading")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pTPrimary)
                .padding(.top, 50)
                .ignoresSafeArea(edges: .top)

            List(viewModel.currentlyReadingBooks, id: \.id) { book in 
                HStack {
                BookRow(book: book, viewModel: viewModel)
                
                    
//                    Button(action: {
//                        viewModel.deleteBookFromFirestore(bookId: book.id, listType: .currentlyReading)
//                    }) {
//                        Image(systemName: "trash")
//                            .foregroundColor(.red)
//                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .tint(.ptSecondary)
        }
    }
}

struct ListCurrentlyReadingView_Preview: PreviewProvider {
    static var previews: some View {
        ListCurrentlyReadingView(viewModel: BooksListViewModel(userId: "CF1SJXYsPnMu85IGAoeLKJjwx6t1"))
    }
}
