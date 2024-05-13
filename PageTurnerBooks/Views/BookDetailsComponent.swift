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
            VStack(alignment: .leading, spacing: 23) {
                Spacer()
                Spacer()
                HStack(alignment: .center) {
                    thumbnailView
                        .frame(width: 120, height: 120)
                        .opacity(0.3)
                        .shadow(radius: 2)

                    thumbnailView
                        .frame(width: 150, height: 150)
                        .shadow(radius: 3)
                        .scaleEffect(1.1)

                    thumbnailView
                        .frame(width: 120, height: 120)
                        .opacity(0.3)
                        .shadow(radius: 2)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 70)
                
                VStack(spacing: 10) {
                    Text(bookItem.volumeInfo.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        
                    
                    if let subtitle = bookItem.volumeInfo.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .padding(.leading)
                            .padding(.trailing)
                            .multilineTextAlignment(.center)
                    }
                    if let authors = bookItem.volumeInfo.authors, !authors.isEmpty {
                        Text("\(authors.joined(separator: ", "))")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                            .padding(.leading)
                            .padding(.trailing)
                    } else {
                        Text("Unknown author")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                
                Menu {
                    Button(action: {
                        viewModel.addBookToFirestore(book: bookItem, listType: .wantToRead) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    }) {
                        HStack{
                            Text("Want to Read")
                            Spacer()
                            if viewModel.isBookInList(bookId: bookItem.id, listType: .wantToRead) {
                                Image(systemName: "checkmark").foregroundColor(.green)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        viewModel.addBookToCurrentlyReadingAndTrack(book: bookItem) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    }) {
                        HStack{
                            Text("Currently Reading")
                            Spacer()
                            if viewModel.isBookInList(bookId: bookItem.id, listType: .currentlyReading) {
                                Image(systemName: "checkmark").foregroundColor(Color.pTPrimary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        viewModel.addBookToFinishedReadingAndTrack(book: bookItem) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    }) {
                        HStack{
                            Text("Finished Reading")
                            Spacer()
                            if viewModel.isBookInList(bookId: bookItem.id, listType: .finishedReading) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.pTPrimary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                } label: {
                    Text("Add to List")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                        
                }
                .menuStyle(CustomMenuStyle())
                .frame(maxWidth: .infinity, alignment: .center)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Book Addition Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        
                }
                    
                VStack {
                    HStack{
                        Text(bookItem.volumeInfo.description ?? "No description available.")
                    }
                    .padding(.bottom, 15)
                    
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
                .padding(.leading)
                .padding(.trailing)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    
    private var thumbnailView: some View {
        Group {
            if let thumbnailURL = bookItem.volumeInfo.imageLinks?.thumbnail, let url = URL(string: thumbnailURL) {
                
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 150, maxHeight: 250)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                    },
                    placeholder: {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(maxWidth: 150, minHeight: 250)
                            .cornerRadius(8)
                    }
                )
                
                
            } else {
                Rectangle() // Placeholder for books without thumbnails
                    .fill(Color.gray)
                    .frame(maxWidth: 150, minHeight: 250)
                    .cornerRadius(8)
            }
        }
    }
}
    
struct BookDetailComponent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BooksListViewModel(userId: "9laC5umqf4T6fviudjD6HcuN1pW2")
        let book = BookItem(id: "1", volumeInfo: VolumeInfo(title: "Harry Potter and the Sorcerers Stone", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", authors: ["Agatha Christie"], publishedDate: "1984", pageCount: 346, language: "en", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tristique metus molestie, auctor lorem vel, iaculis mauris. Phasellus fringilla tortor ac efficitur gravida. Cras fermentum eget velit accumsan viverra. Vestibulum fermentum purus nisi, eu pellentesque purus euismod sit amet. Nunc nibh nunc, euismod eget rhoncus sit amet, maximus imperdiet odio. Mauris mattis mollis iaculis. Morbi at diam risus. Praesent vestibulum commodo nibh quis volutpat. Integer sit amet malesuada magna. Vivamus augue tortor, elementum a efficitur at, interdum placerat nibh. Aenean id magna lectus. Donec semper lorem eget laoreet condimentum. Fusce hendrerit et leo sed elementum. Etiam sagittis sapien nulla, ac rhoncus leo laoreet imperdiet. Proin leo magna, dapibus et consectetur in, imperdiet maximus nulla.", imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=m8LyAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api", thumbnail: "http://books.google.com/books/content?id=m8LyAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"), categories: ["Category 1", "Category 2"]))
        return BookDetailView(viewModel: viewModel, bookItem: book)
    }
}
    

