//
//  Tracker.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct TrackerView: View {
    @ObservedObject var viewModel: BookTrackerViewModel
    @ObservedObject var listViewModel: BooksListViewModel
    @State private var lastPageString: String = ""
    @State private var isEditing: Bool = false
    @State private var showingConfirmation = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Text("Tracker 📖")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                Section {
                    VStack(spacing: 30) {
                        Text(viewModel.tracker.bookTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        //TODO: Needs testing on a trackable book
                        DatePicker("Start Date", selection: Binding<Date>(
                            get: { viewModel.tracker.startDate },
                            set: { newDate in
                                viewModel.updateStartDate(bookId: viewModel.tracker.id, startDate: newDate)
                            }
                        ), displayedComponents: .date)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //TODO: Needs testing on a trackable book
                        DatePicker("End Date", selection: Binding<Date>(
                            get: { viewModel.tracker.endDate ?? Date() },
                            set: { newDate in
                                viewModel.updateEndDate(bookId: viewModel.tracker.id, endDate: newDate)
                            }
                        ), displayedComponents: .date)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //TODO: Needs to re-direct to ListFinishedReadingView?
                        Button("Finish Reading") {
                            showingConfirmation = true
                        }
                        .alert(isPresented: $showingConfirmation) {
                            Alert(
                                title: Text("Confirm Finish"),
                                message: Text("Are you sure you want to mark this book as finished?"),
                                primaryButton: .destructive(Text("Finish")) {
                                    listViewModel.completeBookAndMoveToFinished(bookId: viewModel.tracker.id)
                                    presentationMode.wrappedValue.dismiss()
                                },
                                secondaryButton: .cancel()
                            )
                        }

                        HStack {
                            Text("Last Page Read:")
                                .fontWeight(.bold)

                            if isEditing {
                                TextField("", text: $lastPageString)
                                    .frame(width: 70, height: 30)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            } else {
                                Text("\(viewModel.tracker.lastPageRead)")
                                    .fontWeight(.bold)
                            }

                            Button(isEditing ? "Save" : "Edit") {
                                if isEditing {
                                    let lastPage = Int(lastPageString) ?? viewModel.tracker.lastPageRead
                                    viewModel.updateLastPageRead(bookId: viewModel.tracker.id, lastPage: lastPage)
                                } else {
                                    lastPageString = "\(viewModel.tracker.lastPageRead)"
                                }
                                isEditing.toggle()
                            }
                            .padding(.leading, 10)
                        }

                        Text("Total page count: \(viewModel.tracker.totalPageCount)")

                        ProgressView(value: Double(viewModel.tracker.lastPageRead), total: Double(viewModel.tracker.totalPageCount))
                            .progressViewStyle(LinearProgressViewStyle())
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .padding()

                        Text(String(format: "%.1f%% Complete", (Double(viewModel.tracker.lastPageRead) / Double(viewModel.tracker.totalPageCount)) * 100))
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchTracking()
        }
    }
}


//struct TrackerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackerView(viewModel: BookTrackerViewModel(userId: "testUserID", tracker: BookTrackerModel(id: "testID", userId: "testUserID", startDate: Date(), endDate: nil, lastPageRead: 50, totalPageCount: 300, bookTitle: "Harry Potter and the Sorcerer's Stone")))
//    }
//}
