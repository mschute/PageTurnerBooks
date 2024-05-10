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
                        BookRow(book: book, viewModel: viewModel)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            ZStack {
                                Text("View Tracking")
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .padding(9)
                                    .background(Color.pTSecondary)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.pTSecondary)
                                    )

                                NavigationLink(destination: TrackerView(viewModel: BookTrackerViewModel(userId: viewModel.userId, tracker: BookTrackerModel(id: book.id, userId: viewModel.userId, startDate: Date(), endDate: nil, lastPageRead: 0, totalPageCount: book.volumeInfo.pageCount ?? 0, bookTitle: book.volumeInfo.title)), listViewModel: viewModel)) {
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: 105, height: 30) // Confine the area of the NavigationLink
                                .opacity(0.0) // Make the link itself invisible
                            }
                            
                            Spacer()

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
                        .padding(.vertical, 5)
                    }
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
