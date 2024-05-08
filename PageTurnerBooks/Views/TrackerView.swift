//
//  Tracker.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

import SwiftUI

struct TrackerView: View {
    @ObservedObject var viewModel: BookTrackerViewModel
    @State private var lastPageString: String = ""
    @State private var isEditing: Bool = false

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

                        DatePicker("Start Date", selection: $viewModel.tracker.startDate, displayedComponents: .date)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button("Finished") {
                            // Placeholder for functionality
                        }
                        .foregroundColor(.red)
                        .buttonStyle(BorderlessButtonStyle())

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

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(viewModel: BookTrackerViewModel(userId: "testUserID", tracker: BookTrackerModel(id: "testID", userId: "testUserID", startDate: Date(), endDate: nil, lastPageRead: 50, totalPageCount: 300, bookTitle: "Harry Potter and the Sorcerer's Stone")))
    }
}
