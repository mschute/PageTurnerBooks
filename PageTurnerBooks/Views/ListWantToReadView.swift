//
//  ListWantToReadView.swift

import SwiftUI

enum ActiveAlert: Identifiable {
    case confirmDelete, confirmMove, moveSuccess
    
    var id: Int {
        switch self {
        case .confirmDelete:
            return 1
        case .confirmMove:
            return 2
        case .moveSuccess:
            return 3
        }
    }
}

struct ListWantToReadView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @State private var activeAlert: ActiveAlert?
    @State private var bookToDelete: BookItem?
    @State private var bookToMove: BookItem?

    var body: some View {
        VStack {
            Text("Want to Read")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pTPrimary)
                .padding(.top, 50)
                .ignoresSafeArea()

            List(viewModel.wantToReadBooks, id: \.id) { book in
                HStack {
                    BookRow(book: book, viewModel: viewModel)

                    Button(action: {
                        bookToDelete = book
                        activeAlert = .confirmDelete
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button("Move to Currently Reading") {
                        bookToMove = book
                        activeAlert = .confirmMove
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
                    .padding(.leading, 5)
                }
            }
            .listStyle(GroupedListStyle())
            .tint(.ptSecondary)
        }
        .alert(item: $activeAlert) { alert -> Alert in
            switch alert {
            case .confirmDelete:
                return Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete '\(bookToDelete?.volumeInfo.title ?? "this book")'?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let bookToDelete = bookToDelete {
                            viewModel.deleteBookFromFirestore(bookId: bookToDelete.id, listType: .wantToRead)
                        }
                    },
                    secondaryButton: .cancel() {
                        bookToDelete = nil
                    }
                )
            case .confirmMove:
                return Alert(
                    title: Text("Confirm Move"),
                    message: Text("Are you sure you want to move '\(bookToMove?.volumeInfo.title ?? "this book")' to Currently Reading?"),
                    primaryButton: .default(Text("Confirm")) {
                        if let bookToMove = bookToMove {
                            viewModel.moveBookToCurrentlyReading(bookId: bookToMove.id)
                            activeAlert = .moveSuccess
                        }
                    },
                    secondaryButton: .cancel()
                )
            case .moveSuccess:
                return Alert(
                    title: Text("Move to Currently Reading"),
                    message: Text("Successfully moved '\(bookToMove?.volumeInfo.title ?? "this book")' to Currently Reading."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ListWantToRead_Preview: PreviewProvider {
    static var previews: some View {
        ListWantToReadView(viewModel: BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03"))
    }
}
