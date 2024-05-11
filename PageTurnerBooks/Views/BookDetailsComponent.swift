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
            VStack(alignment: .leading, spacing: 20) {
                thumbnailView
                HStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 8) {
                            Text(bookItem.volumeInfo.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            if let subtitle = bookItem.volumeInfo.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                //TODO: Need to create a different style of menu to pick these options. Not sure what would look good right now.
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
                    Button("Add to List", action: {})
                        
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ptSecondary)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Book Addition Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Text(bookItem.volumeInfo.description ?? "No description available.")
                    
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Authors: ")
                            .fontWeight(.bold)
                            .frame(maxWidth: 120, alignment: .leading)
                        
                        if let authors = bookItem.volumeInfo.authors, !authors.isEmpty {
                            Text("\(authors.joined(separator: ", "))")
                        } else {
                            Text("Unknown")
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Published: ")
                            .fontWeight(.bold)
                            .frame(maxWidth: 120, alignment: .leading)
                        
                        if let publishedDate = bookItem.volumeInfo.publishedDate, !publishedDate.isEmpty {
                            Text("\(publishedDate)")
                        } else {
                            Text("Date not available")
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)

                    HStack {
                        Text("Pages: ")
                            .fontWeight(.bold)
                            .frame(maxWidth: 120, alignment: .leading)
                        
                        if let pageCount = bookItem.volumeInfo.pageCount {
                            Text("\(pageCount)")
                        } else {
                            Text("Page count not available")
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Language: ")
                            .fontWeight(.bold)
                            .frame(maxWidth: 120, alignment: .leading)
                        
                        if let language = bookItem.volumeInfo.language, !language.isEmpty {
                            Text("\(language)")
                        } else {
                            Text("Not specified")
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(alignment: .top) {
                        Text("Categories:")
                            .fontWeight(.bold)
                            .frame(maxWidth: 120, alignment: .leading)
                        if let categories = bookItem.volumeInfo.categories, !categories.isEmpty {
                            VStack(alignment: .leading) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            Spacer()
                        } else {
                            Text("No category available")
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
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
                            .frame(maxWidth: .infinity, minHeight: 250)
                            .cornerRadius(8)
                    }
                )
            } else {
                Rectangle() // Placeholder for books without thumbnails
                    .fill(Color.secondary)
                    .frame(maxWidth: .infinity, minHeight: 250)
                    .cornerRadius(8)
            }
        }
    }
}
    
struct BookDetailComponent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2") // Initialize your view model here
        let book = BookItem(id: "1", volumeInfo: VolumeInfo(title: "Sample Book", subtitle: "Subtitle sample book", authors: ["Author1", "Author2"], publishedDate: "1984", pageCount: 346, language: "en", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tristique metus molestie, auctor lorem vel, iaculis mauris. Phasellus fringilla tortor ac efficitur gravida. Cras fermentum eget velit accumsan viverra. Vestibulum fermentum purus nisi, eu pellentesque purus euismod sit amet. Nunc nibh nunc, euismod eget rhoncus sit amet, maximus imperdiet odio. Mauris mattis mollis iaculis. Morbi at diam risus. Praesent vestibulum commodo nibh quis volutpat. Integer sit amet malesuada magna. Vivamus augue tortor, elementum a efficitur at, interdum placerat nibh. Aenean id magna lectus. Donec semper lorem eget laoreet condimentum. Fusce hendrerit et leo sed elementum. Etiam sagittis sapien nulla, ac rhoncus leo laoreet imperdiet. Proin leo magna, dapibus et consectetur in, imperdiet maximus nulla.", imageLinks: nil, categories: ["Category 1", "Category 2"]))
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
    

