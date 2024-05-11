//
//  Lists.swift

import SwiftUI

struct ListsView: View {
    @ObservedObject var viewModel: BooksListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0){
                    Text("Reading List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 0)
                        .background(Color.pTPrimary)
                        .padding(.top, 80)
                        .padding(.bottom, 32)
                        .background(Color.pTPrimary)
                        .edgesIgnoringSafeArea(.top)
                    
                    ScrollView {
                        VStack {
                            NavigationLink(destination: ListWantToReadView(viewModel: viewModel)) {
                                Image("WantToRead")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 150)
                                    .overlay(Rectangle().foregroundColor(Color.black.opacity(0.4)))
                                    .overlay(Text("Want to Read")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white))
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)

                            NavigationLink(destination: ListCurrentlyReadingView(viewModel: viewModel)) {
                                Image("CurrentlyReading")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 150)
                                    .overlay(Rectangle().foregroundColor(Color.black.opacity(0.4)))
                                    .overlay(Text("Currently Reading")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white))
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)

                            NavigationLink(destination: ListFinishedReadingView(viewModel: viewModel)) {
                                Image("FinishedReading")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 150)
                                    .overlay(Rectangle().foregroundColor(Color.black.opacity(0.37)))
                                    .overlay(Text("Finished Reading")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }
        .tint(.white)
    }
}

struct ListsView_Preview: PreviewProvider {
    static var previews: some View {
        ListsView(viewModel: BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2"))
    }
}
