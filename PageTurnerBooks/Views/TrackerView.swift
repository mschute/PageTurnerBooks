//
//  Tracker.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct TrackerView: View {
    @ObservedObject var viewModel: BookTrackerViewModel
    @State private var lastPageString: String = ""
    @State private var progressText: String = ""
    @State private var pageCount: String = ""
    @State private var hiddenDate: Date = Date()
    @State private var showDate: Bool = false
    @State var date: Date?
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
            NavigationView {
                Form {
                    Section(header: Text("Tracking Details")){
                        VStack(spacing: 30){
                            Text("Tracker 📖")
                                .font(.largeTitle)
                            Text("\(viewModel.tracker.bookTitle)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            DatePicker("Start Date", selection: $viewModel.tracker.startDate, displayedComponents: .date)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(){
                                Text("End Date")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                                if showDate {
                                    Button {
                                        showDate = false
                                        date = nil
                                    } label: {
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                            .tint(.black)
                                    }
                                    DatePicker("", selection: $viewModel.tracker.endDate, displayedComponents: .date)
                                        .fontWeight(.bold)
                                        .onChange(of: hiddenDate){ oldDate,
                                            newDate in viewModel.tracker.endDate = newDate
                                        }
                                        .labelsHidden()
                                    
                                } else {
                                    Button {
                                        showDate = true
                                        date = hiddenDate
                                        
                                    } label: {
                                        Text("Add date")
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 100, height: 34)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue)
                                    )
                                }
                            }
                            .fontWeight(.bold)
                        }
                        
                        //Decimalpad bug, not removing the keyboard after selecting out of the textfield
                        LabeledContent{
                            TextField("Enter last page you read", text: $lastPageString)
                                .keyboardType(.decimalPad)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onAppear {
                                    lastPageString = String(viewModel.tracker.lastPageRead)
                                }
                                .onChange(of: lastPageString, {  oldValue, newValue
                                    in
                                    if let lastPage = Int(newValue), lastPage <= viewModel.tracker.totalPageCount {
                                        viewModel.tracker.lastPageRead = lastPage
                                    } else if let _ = Int(newValue) {
                                        lastPageString = String(viewModel.tracker.totalPageCount)
                                        viewModel.tracker.lastPageRead = viewModel.tracker.totalPageCount
                                    }
                                })
                        } label: {
                            Text("Last page")
                                .fontWeight(.bold)
                                .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                            VStack(spacing: 10) {
                                Section(header: Text("Progress")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                ) {
                                    
                                    VStack(spacing: 5){
                                        Text(String(format: "%.2f", viewModel.tracker.progress * 100) + "%")
                                            .padding(.bottom)
                                        
                                        ProgressView(value: viewModel.tracker.progress){}
                                            .scaleEffect(x: 1, y: 4, anchor: .center)
                                        
                                        Text(pageCount + " pages")
                                            .font(.caption)
                                            .padding(4)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .onAppear {
                                                pageCount = String(viewModel.tracker.totalPageCount)
                                            }
                                            .onChange(of: pageCount, { oldValue, newValue in
                                                if let pageCount = Int(newValue) {
                                                    viewModel.tracker.totalPageCount = pageCount
                                                }
                                            })
                                    }
                                }
                            }
                        }
                        .padding(10)
                        
                        //Need to adjust code so that it saves the progress
                        CustomButton(title: "Save") {
                            print("Saved was pressed")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    // Need to link button so it stops tracking this book and deletes this BookTrackerModel
                    // Perhaps add a pop-up asking if they are sure they want to delete their progress
                    Button("Stop Tracking") {
                        print("Stop tracking was pressed")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                }
            }
        }
        .globalBackground()
    }
}


struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleModel = BookTrackerModel(startDate: Date(), endDate: Date(), lastPageRead: 100, totalPageCount: 300, bookTitle: "Harry Potter and the Scorcerers Stone")
        let viewModel = BookTrackerViewModel(tracker: sampleModel)
        
        TrackerView(viewModel: viewModel)
    }
}

