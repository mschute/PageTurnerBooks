//
//  BookDetailsComponent.swift

import SwiftUI

struct BookDetailComponent: View {
    @ObservedObject var viewModel: BooksListViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let bookItem: BookItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                thumbnailView
                    VStack(alignment: .center, spacing: 8) {
                        Text(bookItem.volumeInfo.title)
                            .font(.title)
                        if let subtitle = bookItem.volumeInfo.subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                        }
                        if let authors = bookItem.volumeInfo.authors, !authors.isEmpty {
                            Text("Authors: \(authors.joined(separator: ", "))")
                        } else {
                            Text("Authors: Unknown")
                        }
                    }
                    .multilineTextAlignment(.center)
                
                
                Menu {
                    Button("Want to Read") {
                        viewModel.addBookToFirestore(book: bookItem, listType: .wantToRead) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    }
                    Button("Currently Reading") {
                        viewModel.addBookToCurrentlyReadingAndTrack(book: bookItem) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    }
                    Button("Finished Reading") {
                        viewModel.addBookToFinishedReadingAndTrack(book: bookItem) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    }
                } label: {
                    Button("Add to List", action: {}).fixedSize()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Book Addition Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Text(bookItem.volumeInfo.description ?? "No description available.")
                    .padding(.top)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Published: \(bookItem.volumeInfo.publishedDate ?? "Date not available")")
                    if let pageCount = bookItem.volumeInfo.pageCount {
                        Text("Pages: \(pageCount)")
                    }
                    Text("Language: \(bookItem.volumeInfo.language ?? "Not specified")")
                    if let categories = bookItem.volumeInfo.categories, !categories.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Categories:")
                                .font(.headline)
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                                    .padding(.leading, 10)
                            }
                        }
                    }
                }
                
            }
            .padding(30)
        }
    }
    
    private var thumbnailView: some View {
        Group {
            if let thumbnailURL = bookItem.volumeInfo.imageLinks?.thumbnail, let url = URL(string: thumbnailURL) {
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .cornerRadius(8)
                    },
                    placeholder: {
                        Rectangle() // A better placeholder than just text
                            .fill(Color.pTPrimary)
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .cornerRadius(8)
                    }
                )
            } else {
                //Rectangle() // Placeholder for books without thumbnails
                Image("PageTurnerLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                //.fill(Color.pTPrimary)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                
                
            }
        }
    }
}
    
struct BookDetailComponent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2") // Initialize your view model here
        let book = BookItem(id: "1", volumeInfo: VolumeInfo(title: "Sample Book", subtitle: "Subtitle sample book", authors: ["Author1", "Author2"], publishedDate: "1984", pageCount: 346, language: "en", description: "There once was a boy, ok. This is boring, fuck this. Just read the fucking description. That's all you need, this book is a piece of shit. Be happy that you didn't waste your time any more than you should have. There we go. You have it. Now just fuck off.", imageLinks: nil, categories: ["Cuck fantasy"]))
        return BookDetailView(viewModel: viewModel, bookItem: book)
    }
}

    
    //    var body: some View {
    //            ScrollView {
    //                VStack(alignment: .leading, spacing: 12) {
    //                    thumbnailAndDetailsView
    //                    descriptionView
    //                    metadataView
    //                    addToListView
    //                }
    //                .padding()
    //            }
    //        }
    //
    //    private var addToListView: some View {
    //        Menu {
    //            Button("Want to Read") {
    //                viewModel.addBookToFirestore(book: bookItem, listType: .wantToRead) { success, message in
    //                    alertMessage = message
    //                    showAlert = true
    //                }
    //            }
    //            Button("Currently Reading") {
    //                viewModel.addBookToCurrentlyReadingAndTrack(book: bookItem) { success, message in
    //                    alertMessage = message
    //                    showAlert = true
    //                }
    //            }
    //            Button("Finished Reading") {
    //                viewModel.addBookToFinishedReadingAndTrack(book: bookItem) { success, message in
    //                    alertMessage = message
    //                    showAlert = true
    //                }
    //            }
    //        } label: {
    //            Button("Add to List", action: {}).fixedSize()
    //        }
    //        .alert(isPresented: $showAlert) {
    //            Alert(title: Text("Book Addition Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
    //        }
    //    }
    //
    //
    //    private var thumbnailAndDetailsView: some View {
    //        HStack {
    //            thumbnailView
    //            VStack(alignment: .leading, spacing: 8) {
    //                Text(bookItem.volumeInfo.title)
    //                    .font(.title)
    //                if let subtitle = bookItem.volumeInfo.subtitle {
    //                    Text(subtitle)
    //                        .font(.subheadline)
    //                }
    //                if let authors = bookItem.volumeInfo.authors, !authors.isEmpty {
    //                    Text("Authors: \(authors.joined(separator: ", "))")
    //                } else {
    //                    Text("Authors: Unknown")
    //                }
    //            }
    //        }
    //    }
    //
    //    private var thumbnailView: some View {
    //        Group {
    //            if let thumbnailURL = bookItem.volumeInfo.imageLinks?.thumbnail, let url = URL(string: thumbnailURL) {
    //                AsyncImage(
    //                    url: url,
    //                    content: { image in
    //                        image.resizable()
    //                             .aspectRatio(contentMode: .fit)
    //                             .frame(width: 100, height: 150)
    //                             .cornerRadius(8)
    //                    },
    //                    placeholder: {
    //                        Rectangle() // A better placeholder than just text
    //                            .fill(Color.secondary)
    //                            .frame(width: 100, height: 150)
    //                            .cornerRadius(8)
    //                    }
    //                )
    //            } else {
    //                Rectangle() // Placeholder for books without thumbnails
    //                    .fill(Color.secondary)
    //                    .frame(width: 100, height: 150)
    //                    .cornerRadius(8)
    //            }
    //        }
    //    }
    //
    //    private var descriptionView: some View {
    //        Text(bookItem.volumeInfo.description ?? "No description available.")
    //            .padding(.top)
    //    }
    //
    //    private var metadataView: some View {
    //        VStack(alignment: .leading, spacing: 8) {
    //            Text("Published: \(bookItem.volumeInfo.publishedDate ?? "Date not available")")
    //            if let pageCount = bookItem.volumeInfo.pageCount {
    //                Text("Pages: \(pageCount)")
    //            }
    //            Text("Language: \(bookItem.volumeInfo.language ?? "Not specified")")
    //            if let categories = bookItem.volumeInfo.categories, !categories.isEmpty {
    //                VStack(alignment: .leading) {
    //                    Text("Categories:")
    //                        .font(.headline)
    //                    ForEach(categories, id: \.self) { category in
    //                        Text(category)
    //                            .padding(.leading, 10)
    //                    }
    //                }
    //            }
    //        }
    //    }
    //}
    

