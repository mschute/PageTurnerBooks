//
// BookDetailView.swift

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BooksListViewModel 
    let bookItem: BookItem
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color.pTPrimary)
                        .padding(.leading, 20)
                        .padding(.top, 50)
                    
                }
                Spacer()
            }
            BookDetailComponent(viewModel: viewModel, bookItem: bookItem)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .tint(.pTPrimary)
        .padding(.top, -50)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2")
        let book = BookItem(id: "1", volumeInfo: VolumeInfo(title: "Sample Book", subtitle: "Subtitle sample book", authors: ["Author1", "Author2"], publishedDate: "1984", pageCount: 346, language: "en", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tristique metus molestie, auctor lorem vel, iaculis mauris. Phasellus fringilla tortor ac efficitur gravida. Cras fermentum eget velit accumsan viverra. Vestibulum fermentum purus nisi, eu pellentesque purus euismod sit amet. Nunc nibh nunc, euismod eget rhoncus sit amet, maximus imperdiet odio. Mauris mattis mollis iaculis. Morbi at diam risus. Praesent vestibulum commodo nibh quis volutpat. Integer sit amet malesuada magna. Vivamus augue tortor, elementum a efficitur at, interdum placerat nibh. Aenean id magna lectus. Donec semper lorem eget laoreet condimentum. Fusce hendrerit et leo sed elementum. Etiam sagittis sapien nulla, ac rhoncus leo laoreet imperdiet. Proin leo magna, dapibus et consectetur in, imperdiet maximus nulla", imageLinks: nil, categories: ["Category 1", "Category 2"]))
        return BookDetailView(viewModel: viewModel, bookItem: book)
    }
}

