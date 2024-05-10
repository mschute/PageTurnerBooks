//
//  ListFinishedReading.swift

import SwiftUI

struct ListFinishedReadingView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @State private var showingDeleteAlert = false
    @State private var bookToDelete: BookItem?
    @State private var trackingInfo: [String: (startDate: Date, endDate: Date?)] = [:]

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    private func fetchTrackingData(for bookId: String) {
        viewModel.bookTrackerVM.fetchTrackingForFinishedBook(bookId: bookId) { startDate, endDate in
            DispatchQueue.main.async {
                self.trackingInfo[bookId] = (startDate, endDate)
            }
        }
    }

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
                VStack(alignment: .leading) {
                    BookRow(book: book, viewModel: viewModel)
                    if var dates = trackingInfo[book.id] {
                        
                        DatePicker("End Date", selection: Binding<Date>(
                            get: { dates.endDate ?? Date() },
                            set: { newDate in
                                dates.endDate = newDate
                                viewModel.bookTrackerVM.updateEndDate(bookId: book.id, endDate: newDate)
                                trackingInfo[book.id]?.endDate = newDate  // Update local state
                            }
                        ), displayedComponents: .date)
                    }

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
                                    viewModel.deleteBookFromFirestore(bookId: bookToDelete.id, listType: .finishedReading)
                                }
                            },
                            secondaryButton: .cancel() {
                                bookToDelete = nil
                            }
                        )
                    }
                    .padding(.top, 5)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .tint(.ptSecondary)
        }
        .onAppear {
            for book in viewModel.finishedReadingBooks {
                fetchTrackingData(for: book.id)
            }
        }
    }
}
