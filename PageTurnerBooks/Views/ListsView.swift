//
//  Lists.swift

import SwiftUI

struct ListsView: View {
    @ObservedObject var viewModel: BooksListViewModel
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.pTPrimary.edgesIgnoringSafeArea(.top)
                
                
                VStack(spacing: 0){
                        Text("Reading List")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 0)
                            .background(Color.pTPrimary)
                            .padding(.top, 80)
                            .padding(.bottom, -20)
                    .background(Color.pTPrimary)
                    .edgesIgnoringSafeArea(.top)
                    List {
                        Section {
                            NavigationLink(destination: ListWantToReadView(viewModel: viewModel)) {
                                Text("Want to Read")
                            }
                            
                            NavigationLink(destination: ListCurrentlyReadingView(viewModel: viewModel)) {
                                Text("Currently Reading")
                            }
                            
                            NavigationLink(destination: ListFinishedReadingView(viewModel: viewModel)) {
                                Text("Finished Reading")
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }
    }
}

struct ListsView_Preview: PreviewProvider {
    static var previews: some View {
        ListsView(viewModel: BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2"))
    }
}

