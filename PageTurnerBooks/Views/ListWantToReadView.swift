//
//  ListWantToReadView.swift

import SwiftUI

struct ListWantToReadView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @State private var showingDeleteAlert = false
    @State private var bookToDelete: BookItem?
    @State private var showingMoveAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

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
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
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
                    }

                    Button("Move to Currently Reading") {
                        viewModel.moveBookToCurrentlyReading(bookId: book.id)
                        alertTitle = "Move to Currently Reading"
                        alertMessage = "Successfully moved '\(book.volumeInfo.title)' to Currently Reading."
                        showingMoveAlert = true
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
                    .padding(.leading, 5)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .tint(.ptSecondary)
            .alert(isPresented: $showingMoveAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ListWantToRead_Preview: PreviewProvider {
    static var previews: some View {
        ListWantToReadView(viewModel: BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03"))
    }
}
