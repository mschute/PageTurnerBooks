//
//  TrackerView.swift

import SwiftUI

struct TrackerView: View {
    @ObservedObject var viewModel: BookTrackerViewModel
    @ObservedObject var listViewModel: BooksListViewModel
    @State private var lastPageString: String = ""
    @State private var isEditing: Bool = false
    @State private var showingConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 0){
                    Text("Tracker")
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pTPrimary)
                        .ignoresSafeArea(edges: .horizontal)
                        .ignoresSafeArea(edges: .bottom)
                        
                    Form {
                        Section {
                            VStack(spacing: 30) {
                                Text(viewModel.tracker.bookTitle)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                DatePicker("Start Date: ", selection: Binding<Date>(
                                    get: { viewModel.tracker.startDate },
                                    set: { newDate in
                                        viewModel.updateStartDate(bookId: viewModel.tracker.id, startDate: newDate)
                                    }
                                ), displayedComponents: .date)
                                .fontWeight(.bold)
                                .tint(.ptSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                                
                                HStack() {
                                    Text("Last Page Read: ")
                                        .fontWeight(.bold)
                                    
                                    //Note: This works in the build but not in the preview
                                    if isEditing {
                                        TextField("", text: $lastPageString)
                                            .frame(width: 70, height: 30)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.numberPad)
                                    } else {
                                        Text("\(viewModel.tracker.lastPageRead)")
                                        
                                    }
                                    Spacer()
                                    //TODO: Is this edit button too chunky? Would you prefer regular styling?
                                    HStack{
                                        Button(isEditing ? "Save" : "Edit") {
                                            if isEditing {
                                                let lastPage = Int(lastPageString) ?? viewModel.tracker.lastPageRead
                                                viewModel.updateLastPageRead(bookId: viewModel.tracker.id, lastPage: lastPage)
                                            } else {
                                                lastPageString = "\(viewModel.tracker.lastPageRead)"
                                            }
                                            isEditing.toggle()
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .buttonStyle(PlainButtonStyle()) //Need to keep to prevent erroneous behaviour
                                        .background(.ptSecondary)
                                        .font(.system(size: 18, weight: .bold))
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                        .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .trailing)
                                        .foregroundColor(Color.white)
                                    }
                                }
                                Divider()
                                HStack{
                                    Text("Total Pages:        ")
                                        .fontWeight(.bold)
                                    Text("\(viewModel.tracker.totalPageCount)")
                                    Spacer()
                                }
                                
                                ProgressView(value: Double(viewModel.tracker.lastPageRead), total: Double(viewModel.tracker.totalPageCount))
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .scaleEffect(x: 1.1, y: 4, anchor: .center)
                                    .tint(.ptPrimary)
                                    .padding()
                                
                                Text(String(format: "%.1f%% Complete", (Double(viewModel.tracker.lastPageRead) / Double(viewModel.tracker.totalPageCount)) * 100))
                                    .font(.system(size: 21, weight: .semibold))
                                
                                Divider()
                                Section {
                                    Button("Finish Reading") {
                                        showingConfirmation = true
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .buttonStyle(PlainButtonStyle()) //Need to keep to prevent erroneous behaviour
                                    .background(.ptSecondary)
                                    .font(.system(size: 18, weight: .bold))
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                    .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
                                    .foregroundColor(Color.white)
                                    
                                }
                            }
                        }
                        .padding(.bottom, 20)
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
        let bookListViewModel = BooksListViewModel(userId: "xR8M6o1Km9WCyJiePsNvXlVsAH03")
        
        TrackerView(viewModel: BookTrackerViewModel(userId: "testUserID", tracker: BookTrackerModel(id: "testID", userId: "testUserID", startDate: Date(), endDate: nil, lastPageRead: 50, totalPageCount: 300, bookTitle: "Harry Potter and the Sorcerer's Stone")), listViewModel: bookListViewModel)
    }
}
