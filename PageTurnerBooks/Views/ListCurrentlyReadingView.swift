//
//  ListCurrentlyReadingView.swift

import SwiftUI

struct ListCurrentlyReadingView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @State private var showingDeleteAlert = false
    @State private var bookToDelete: BookItem?
    @State private var selectedBook: BookItem?
    @State private var isTrackingNavigationActive = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .padding(.leading, 15)
                            .padding(.bottom, 6)
                    }
                    
                    Text("Currently Reading")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 3)
                        .padding(.bottom, 12)
                    
                    Spacer()
                        .frame(maxWidth: 35)
                }
                .background(Color.pTPrimary)
                .ignoresSafeArea(edges: .horizontal)
                .ignoresSafeArea(edges: .bottom)
                
                List(viewModel.currentlyReadingBooks, id: \.id) { book in
                    VStack{
                        BookRow(book: book, viewModel: viewModel)
                        
                        HStack {
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
                                .onTapGesture {
                                    self.selectedBook = book
                                    DispatchQueue.main.async {
                                        self.isTrackingNavigationActive = true
                                    }
                                }
                            
                            NavigationLink(destination: TrackerView(viewModel: BookTrackerViewModel(userId: viewModel.userId, tracker: BookTrackerModel(id: book.id, userId: viewModel.userId, startDate: Date(), endDate: nil, lastPageRead: 0, totalPageCount: book.volumeInfo.pageCount ?? 0, bookTitle: book.volumeInfo.title)), listViewModel: viewModel), isActive: Binding(
                                get: { self.selectedBook?.id == book.id && self.isTrackingNavigationActive },
                                set: { isActive in
                                    if !isActive {
                                        self.isTrackingNavigationActive = false
                                    }
                                }
                                    
                            )) {
                                EmptyView()
                                    
                            }
                            .hidden()
                            
                            
                            Spacer()
                            
                            Button(action: {
                                bookToDelete = book
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.pTWarning)
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
                .padding(.top, -10)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ListCurrentlyReadingView_Preview: PreviewProvider {
    static var previews: some View {
        ListCurrentlyReadingView(viewModel: BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03"))
    }
}
