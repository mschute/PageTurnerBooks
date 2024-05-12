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
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .padding(.leading, 15)
                }
                Text("Want to Read")
                    .frame(maxWidth: .infinity)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 11)
                
                Spacer()
                    .frame(maxWidth: 35)
            }
            .padding(.top, 51)
            .background(Color.pTPrimary)
            .ignoresSafeArea(edges: .horizontal)
            .ignoresSafeArea(edges: .bottom)

            List(viewModel.wantToReadBooks, id: \.id) { book in
                VStack(alignment: .leading) {
                    BookRow(book: book, viewModel: viewModel)
                    
                    HStack {
                        Button("Start Reading") {
                            bookToMove = book
                            activeAlert = .confirmMove
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(9)
                        .background(Color.pTSecondary)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.pTSecondary)
                        )
                        .padding(.trailing, 10)
                        
                        Spacer()

                        Button(action: {
                            bookToDelete = book
                            activeAlert = .confirmDelete
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.pTWarning)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 10)
                }
            }
            .listStyle(GroupedListStyle())
            .tint(.ptSecondary)
            .padding(.top, -10)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
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
                    message: Text("Are you sure you want to move '\(bookToMove?.volumeInfo.title ?? "this book")' to Currently Reading and begin Tracking?"),
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
                    title: Text("Moved to Currently Reading"),
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
