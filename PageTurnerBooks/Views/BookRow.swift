//
//  BookRow.swift

import SwiftUI

struct BookRow: View {
    var book: BookItem
    @ObservedObject var viewModel: BooksListViewModel

    var body: some View {
        NavigationLink(destination: BookDetailView(viewModel: viewModel, bookItem: book)) {
            HStack {
                thumbnailAndDetails
            }
        }
    }

    private var thumbnailAndDetails: some View {
        Group {
            if let thumbnailURL = book.volumeInfo.imageLinks?.thumbnail, let url = URL(string: thumbnailURL) {
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 50, height: 80)
                             .cornerRadius(5)
                    },
                    placeholder: {
                        Rectangle() // Placeholder for books without thumbnails
                            .fill(Color.secondary)
                            .frame(width: 50, height: 80)
                            .cornerRadius(5)
                    }
                )
            } else {
                Rectangle() // Placeholder for books without thumbnails
                    .fill(Color.secondary)
                    .frame(width: 50, height: 80)
                    .cornerRadius(5)
            }

            VStack(alignment: .leading) {
                Text(book.volumeInfo.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(book.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Authors")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.leading, 8)
        }
    }
}
