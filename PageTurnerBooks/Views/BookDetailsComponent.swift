//
//  BookDetailsComponent.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 05/05/2024.
//

import SwiftUI

struct BookDetailComponent: View {
    @ObservedObject var viewModel: BooksListViewModel
    let bookItem: BookItem

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    thumbnailAndDetailsView
                    descriptionView
                    metadataView
                    addToListView
                }
                .padding()
            }
        }
    
    private var addToListView: some View {
            Menu {
                Button("Want to Read", action: { viewModel.addBookToFirestore(book: bookItem, listType: .wantToRead) })
                Button("Currently Reading", action: { viewModel.addBookToFirestore(book: bookItem, listType: .currentlyReading) })
                Button("Finished Reading", action: { viewModel.addBookToFirestore(book: bookItem, listType: .finishedReading) })
            } label: {
                        // Using CustomButton as the label for the Menu
                        CustomButton(title: "Add to List", action: {})
                            .fixedSize()
                    }
        }
    
    
    private var thumbnailAndDetailsView: some View {
        HStack {
            thumbnailView
            VStack(alignment: .leading, spacing: 8) {
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
        }
    }

    private var thumbnailView: some View {
        Group {
            if let thumbnailURL = bookItem.volumeInfo.imageLinks?.thumbnail, let url = URL(string: thumbnailURL) {
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 100, height: 150)
                             .cornerRadius(8)
                    },
                    placeholder: {
                        Rectangle() // A better placeholder than just text
                            .fill(Color.secondary)
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    }
                )
            } else {
                Rectangle() // Placeholder for books without thumbnails
                    .fill(Color.secondary)
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            }
        }
    }

    private var descriptionView: some View {
        Text(bookItem.volumeInfo.description ?? "No description available.")
            .padding(.top)
    }

    private var metadataView: some View {
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
}
