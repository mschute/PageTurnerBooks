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
    private var bookTrackerVM: BookTrackerViewModel
    
    init(userId: String) {
            self.userId = userId
            // Create a default tracker model
            let defaultTracker = BookTrackerModel(id: "",
                                                  userId: userId,
                                                  startDate: Date(),
                                                  endDate: nil,
                                                  lastPageRead: 0,
                                                  totalPageCount: 0,
                                                  bookTitle: "")
            // Initialize the BookTrackerViewModel with the userId and the default tracker
            self.bookTrackerVM = BookTrackerViewModel(userId: userId, tracker: defaultTracker)
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
    
    func addBookToFirestore(book: BookItem, listType: BookListType, completion: @escaping () -> Void = {}) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        let listCollection = userRef.collection(listType.rawValue)

        var data: [String: Any] = [
            "id": book.id,
            "volumeInfo": [
                "title": book.volumeInfo.title,
                "subtitle": book.volumeInfo.subtitle as Any,
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

        // Set data for the book in Firestore and then execute the completion handler if successful
        listCollection.document(book.id).setData(data) { error in
            if let error = error {
                print("Error adding book: \(error.localizedDescription)")
            } else {
                self.addBookToList(book: book, listType: listType)
                completion()
            }
        }
    }

    
    func deleteBookFromFirestore(bookId: String, listType: BookListType) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        let listCollection = userRef.collection(listType.rawValue)
        let bookDocument = listCollection.document(bookId)
        
        // Delete the tracking data subcollection first
        deleteTrackingData(bookDocument: bookDocument) {
            // After deleting tracking data, delete the book document
            bookDocument.delete { error in
                if let error = error {
                    print("Error deleting book: \(error.localizedDescription)")
                } else {
                    print("Book and tracking data successfully deleted from \(listType.rawValue)")
                }
            }
        }
    }

    func deleteTrackingData(bookDocument: DocumentReference, completion: @escaping () -> Void) {
        let trackingCollection = bookDocument.collection("tracking")
        // Retrieve all documents in the tracking subcollection
        trackingCollection.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No tracking data found or error: \(error?.localizedDescription ?? "Unknown error")")
                completion()
                return
            }
            
            // Use a batch to delete all tracking data documents
            let batch = Firestore.firestore().batch()
            documents.forEach { batch.deleteDocument($0.reference) }
            
            // Commit the batch
            batch.commit { error in
                if let error = error {
                    print("Error deleting tracking data: \(error.localizedDescription)")
                } else {
                    print("Tracking data successfully deleted")
                }
                completion()
            }
        }
    }
    
    func addBookToCurrentlyReadingAndTrack(book: BookItem) {
        // First, add the book to Firestore
        addBookToFirestore(book: book, listType: .currentlyReading) {
            // After the book is added, then update tracking
            let newTracking = BookTrackerModel(
                id: book.id,
                userId: self.userId,
                startDate: Date(),
                endDate: nil,
                lastPageRead: 0,
                totalPageCount: book.volumeInfo.pageCount ?? 0,
                bookTitle: book.volumeInfo.title
            )
            self.bookTrackerVM.updateTracking(bookId: book.id, tracking: newTracking)
        }
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

