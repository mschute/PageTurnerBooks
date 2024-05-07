//
//  Lists.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct ListsView: View {
    @ObservedObject var viewModel: BooksListViewModel
    
    var body: some View {
        NavigationView {
            List {
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
            .navigationBarTitle("Reading Lists")
        }
    }
}



