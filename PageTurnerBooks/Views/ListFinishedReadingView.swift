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
                    
                    HStack {
                        if let dates = trackingInfo[book.id] {
                            Text("End Date:")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold, design: .default))

                            DatePicker("", selection: Binding<Date>(
                                get: { dates.endDate ?? Date() },
                                set: { newDate in
                                    var newDates = dates
                                    newDates.endDate = newDate
                                    trackingInfo[book.id] = newDates
                                    viewModel.bookTrackerVM.updateEndDate(bookId: book.id, endDate: newDate)
                                }
                            ), displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .scaleEffect(0.8)
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
                    }
                    .padding(.vertical, 5)
                }
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
            }
        .listStyle(GroupedListStyle())
        .tint(.ptSecondary)
        .padding(.top, -10)
    }
    .edgesIgnoringSafeArea(.top)
    .onAppear {
        for book in viewModel.finishedReadingBooks {
            fetchTrackingData(for: book.id)
        }
    }
}
}

struct ListFinishedReadingView_Preview: PreviewProvider {
    static var previews: some View {
        ListFinishedReadingView(viewModel: BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03"))
    }
}
