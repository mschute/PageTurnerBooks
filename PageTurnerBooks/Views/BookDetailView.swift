import SwiftUI

struct BookDetailView: View {
    let bookItem: BookItem

    var body: some View {
        BookDetailComponent(bookItem: bookItem)
    }
}
