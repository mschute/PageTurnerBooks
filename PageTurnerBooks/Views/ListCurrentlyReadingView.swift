//
//  ListCurrentlyReadingView.swift

import SwiftUI

struct ListCurrentlyReadingView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @State private var showingDeleteAlert = false
    @State private var bookToDelete: BookItem?

    var body: some View {
        NavigationView {
            VStack{
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
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            BookRow(book: book, viewModel: viewModel)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
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
                                            viewModel.deleteBookFromFirestore(bookId: bookToDelete.id, listType: .currentlyReading)
                                        }
                                    },
                                    secondaryButton: .cancel() {
                                        bookToDelete = nil
                                    }
                                )
                            }
                        }
                        
                        NavigationLink(destination: TrackerView(viewModel: BookTrackerViewModel(userId: viewModel.userId, tracker: BookTrackerModel(id: book.id, userId: viewModel.userId, startDate: Date(), endDate: nil, lastPageRead: 0, totalPageCount: book.volumeInfo.pageCount ?? 0, bookTitle: book.volumeInfo.title)), listViewModel: viewModel)) {
                            Text("Track")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical)
                }
                .listStyle(GroupedListStyle())
                .tint(.ptSecondary)
                .padding(.top, -10)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct ListCurrentlyReadingView_Preview: PreviewProvider {
    static var previews: some View {
        ListCurrentlyReadingView(viewModel: BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03"))
    }
}
