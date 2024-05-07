//
//  BooksListViewModel.swift
//  PageTurnerBooks
//
//  Created by Brad on 06/05/2024.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class BooksListViewModel: ObservableObject {
    @Published var wantToReadBooks: [BookItem] = []
    @Published var currentlyReadingBooks: [BookItem] = []
    @Published var finishedReadingBooks: [BookItem] = []

    private var userId: String

    init(userId: String) {
        self.userId = userId
        // Fetch books from Firestore for each list
        loadBooksFor(listType: .wantToRead)
        loadBooksFor(listType: .currentlyReading)
        loadBooksFor(listType: .finishedReading)
    }

    // Function to load books for a specific list
    func loadBooksFor(listType: BookListType) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        let listCollection = userRef.collection(listType.rawValue)
        print("Fetching books for \(userId) from \(listType.rawValue)")

        // Set up a listener for real-time updates
        listCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching books for \(listType.rawValue): \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents found for \(listType.rawValue)")
                return
            }
            print("Found \(documents.count) documents in \(listType.rawValue)")
            let books = documents.compactMap { queryDocumentSnapshot -> BookItem? in
                try? queryDocumentSnapshot.data(as: BookItem.self)
            }
            print("Loaded \(books.count) books for \(listType.rawValue)")
            DispatchQueue.main.async {
                switch listType {
                case .wantToRead:
                    self.wantToReadBooks = books
                case .currentlyReading:
                    self.currentlyReadingBooks = books
                case .finishedReading:
                    self.finishedReadingBooks = books
                }
            }
        }
    }

    // Function to add a book to a specific list in Firestore and update local state
    func addBookToFirestore(book: BookItem, listType: BookListType) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        let listCollection = userRef.collection(listType.rawValue)

        // Construct the data dictionary to match the nested structure
        var data: [String: Any] = [
            "id": book.id,
            "volumeInfo": [
                "title": book.volumeInfo.title,
                "subtitle": book.volumeInfo.subtitle as Any, // Use 'as Any' to handle optional nils
                "authors": book.volumeInfo.authors as Any,
                "publishedDate": book.volumeInfo.publishedDate as Any,
                "pageCount": book.volumeInfo.pageCount as Any,
                "language": book.volumeInfo.language as Any,
                "description": book.volumeInfo.description as Any,
                "imageLinks": [
                    "smallThumbnail": book.volumeInfo.imageLinks?.smallThumbnail as Any,
                    "thumbnail": book.volumeInfo.imageLinks?.thumbnail as Any
                ],
                "categories": book.volumeInfo.categories as Any
            ]
        ]

        // Adding the book to Firestore with the nested structure
        listCollection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding book: \(error.localizedDescription)")
            } else {
                // Update local state if needed
                self.addBookToList(book: book, listType: listType)
            }
        }
    }
    
    func deleteBookFromFirestore(bookId: String, listType: BookListType) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        let listCollection = userRef.collection(listType.rawValue)

        // Find the document with the corresponding bookId
        listCollection.whereField("id", isEqualTo: bookId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error finding book: \(error.localizedDescription)")
                return
            }

            // Assuming there is one unique entry for each bookId
            if let document = snapshot?.documents.first {
                document.reference.delete() { error in
                    if let error = error {
                        print("Error deleting book: \(error.localizedDescription)")
                    } else {
                        print("Book successfully deleted")
                    }
                }
            }
        }
    }
    
    
    func addBookToCurrentlyReading(book: BookItem) {
        addBookToFirestore(book: book, listType: .currentlyReading)
    }
    
    func addBookToWantToRead(book: BookItem) {
        addBookToFirestore(book: book, listType: .wantToRead)
    }
    
    func addBookToFinishedReading(book: BookItem) {
        addBookToFirestore(book: book, listType: .finishedReading)
    }

    func addBookToList(book: BookItem, listType: BookListType) {
        DispatchQueue.main.async {
            switch listType {
            case .wantToRead:
                self.wantToReadBooks.append(book)
            case .currentlyReading:
                self.currentlyReadingBooks.append(book)
            case .finishedReading:
                self.finishedReadingBooks.append(book)
            }
        }
    }

    // Enum to specify list types
    enum BookListType: String {
        case wantToRead = "WantToRead"
        case currentlyReading = "CurrentlyReading"
        case finishedReading = "FinishedReading"
    }
}

