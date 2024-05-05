//
//  BookRow.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 05/05/2024.
//

import SwiftUI

struct BookRow: View {
    var book: BookItem

    var body: some View {
        NavigationLink(destination: BookDetailView(bookItem: book)) {
            HStack {
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
}
