//
//  ScannerManager.swift

import Foundation
import SwiftUI

class BookManager: CoordinatorDelegate, ObservableObject {
    static let shared = BookManager()
    @Published var books: [BookItem] = []

    func didRetrieveBooks(_ bookItems: [BookItem]) {
        DispatchQueue.main.async {
            self.books = bookItems
        }
    }
}


