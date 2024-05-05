//
//  ScannerManager.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 04/05/2024.
//

import Foundation
import SwiftUI

class BookManager: CoordinatorDelegate, ObservableObject {
    @Published var books: [BookItem] = []

    func didRetrieveBooks(_ bookItems: [BookItem]) {
        DispatchQueue.main.async {
            self.books = bookItems
        }
    }
}


