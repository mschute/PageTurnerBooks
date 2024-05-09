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
            let defaultTracker = BookTrackerModel(
            id: "",
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
    
    func bookExistsInAnyList(bookId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        let lists = ["CurrentlyReading", "FinishedReading", "WantToRead"]

        let dispatchGroup = DispatchGroup()
        var exists = false

        for list in lists {
            dispatchGroup.enter()
            userRef.collection(list).document(bookId).getDocument { (document, error) in
                if let document = document, document.exists {
                    exists = true
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(exists)
        }
    }

    
    func addBookToFirestore(book: BookItem, listType: BookListType, completion: @escaping (Bool, String) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)

        // First, check if the book already exists in any list
        bookExistsInAnyList(bookId: book.id) { exists in
            if exists {
                print("Book already exists in one of the lists.")
                completion(false, "This book is already on one of your lists.") // Notify caller that the book exists
                return // Exit the function if the book already exists
            } else {
                // Proceed with adding the book if it does not exist
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
                        completion(false, "Error adding book: \(error.localizedDescription)") // Notify caller of error
                    } else {
                        print("Book successfully added.")
                        completion(true, "Book successfully added to your \(listType.rawValue) list.") // Notify caller of success
                    }
                }
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
    
    func addBookToCurrentlyReadingAndTrack(book: BookItem, completion: @escaping (Bool, String) -> Void) {
        self.bookExistsInAnyList(bookId: book.id) { exists in
            if exists {
                completion(false, "This book is already on one of your lists.")
            } else {
                self.addBookToFirestore(book: book, listType: .currentlyReading) { success, message in
                    if success {
                        let newTracking = BookTrackerModel(
                            id: book.id,
                            userId: self.userId,
                            startDate: Date(),
                            endDate: nil,
                            lastPageRead: 0,
                            totalPageCount: book.volumeInfo.pageCount ?? 0,
                            bookTitle: book.volumeInfo.title
                        )
                        self.bookTrackerVM.updateTracking(bookId: book.id, tracking: newTracking, trackingStatus: "CurrentlyReading")
                        completion(true, "Book successfully added to your Currently Reading list.")
                    } else {
                        completion(false, message)
                    }
                }
            }
        }
    }

    
    func addBookToFinishedReadingAndTrack(book: BookItem, completion: @escaping (Bool, String) -> Void) {
        self.bookExistsInAnyList(bookId: book.id) { exists in
            if exists {
                completion(false, "This book is already on one of your lists.")
            } else {
                self.addBookToFirestore(book: book, listType: .finishedReading) { success, message in
                    if success {
                        let newTracking = BookTrackerModel(
                            id: book.id,
                            userId: self.userId,
                            startDate: Date(),
                            endDate: Date(),
                            lastPageRead: book.volumeInfo.pageCount ?? 0, // Assume they read all the pages
                            totalPageCount: book.volumeInfo.pageCount ?? 0,
                            bookTitle: book.volumeInfo.title
                        )
                        self.bookTrackerVM.updateTracking(bookId: book.id, tracking: newTracking, trackingStatus: "FinishedReading")
                        completion(true, "Book successfully added to your Finished Reading list.")
                    } else {
                        completion(false, message)
                    }
                }
            }
        }
    }
    
    
    func completeBookAndMoveToFinished(bookId: String) {
        let endDate = Date() // Setting the current date as the end date
        let userRef = Firestore.firestore().collection("Users").document(userId)
        let currentlyReadingRef = userRef.collection("CurrentlyReading").document(bookId)
        let finishedReadingRef = userRef.collection("FinishedReading").document(bookId)

        // Fetch book data from CurrentlyReading
        currentlyReadingRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var bookData = document.data() ?? [:]
                bookData["endDate"] = endDate  // Add the end date to the book data
                
                // Fetch tracking data
                currentlyReadingRef.collection("tracking").document("trackingData").getDocument { (trackingDoc, trackingError) in
                    if let trackingDoc = trackingDoc, trackingDoc.exists {
                        var trackingData = trackingDoc.data() ?? [:]
                        trackingData["endDate"] = endDate  // Add the end date to the tracking data

                        // Start copying process
                        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
                            transaction.setData(bookData, forDocument: finishedReadingRef)
                            transaction.setData(trackingData, forDocument: finishedReadingRef.collection("tracking").document("trackingData"))
                            transaction.deleteDocument(currentlyReadingRef)
                            transaction.deleteDocument(currentlyReadingRef.collection("tracking").document("trackingData"))
                            return nil
                        }) { (object, error) in
                            if let error = error {
                                print("Error moving book to FinishedReading: \(error.localizedDescription)")
                            } else {
                                print("Book successfully moved to FinishedReading with end date")
                            }
                        }
                    } else {
                        print("Error fetching tracking data: \(trackingError?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                print("Error fetching book data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    //TODO: Needs testing on a book within WantToRead list (also needs button/link implemented to test the function in there)
    func moveBookToCurrentlyReading(bookId: String) {
        let wantToReadRef = Firestore.firestore().collection("Users").document(userId)
                                                     .collection("WantToRead").document(bookId)

        // Fetch book data from WantToRead
        wantToReadRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Deserialise the document into a BookItem object
                do {
                    let book = try document.data(as: BookItem.self)
                    
                    // Add the book to CurrentlyReading and set up tracking
                    self.addBookToCurrentlyReadingAndTrack(book: book) { success, message in
                        if success {
                            // Delete the book from WantToRead after successfully moving it to CurrentlyReading
                            wantToReadRef.delete { error in
                                if let error = error {
                                    print("Error deleting book from WantToRead: \(error.localizedDescription)")
                                } else {
                                    print("Book successfully moved from WantToRead to CurrentlyReading")
                                }
                            }
                        } else {
                            print("Failed to move book to Currently Reading: \(message)")
                        }
                    }
                } catch {
                    print("Error decoding book data: \(error.localizedDescription)")
                }
            } else {
                print("Error fetching book data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func addBookToWantToRead(book: BookItem) {
        addBookToFirestore(book: book, listType: .wantToRead) { success, message in
            if success {
                print("Book successfully added to your Want to Read list.")
            } else {
                print("Failed to add book to Want to Read: \(message)")
            }
        }
    }
    
    func addBookToFinishedReading(book: BookItem) {
        addBookToFirestore(book: book, listType: .finishedReading) { success, message in
            if success {
                print("Book successfully added to your Finished Reading list.")
            } else {
                print("Failed to add book to Finished Reading: \(message)")
            }
        }
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

extension BooksListViewModel {
    static var mock: BooksListViewModel {
        let viewModel = BooksListViewModel(userId: "mockUser")
        viewModel.currentlyReadingBooks = [
            BookItem(id: "1", volumeInfo: VolumeInfo(title: "The Great Gatsby", subtitle: "A tale of the Jazz Age", authors: ["F. Scott Fitzgerald"], publishedDate: "1925", pageCount: 218, language: "English", description: "The story of the mysteriously wealthy Jay Gatsby and his love for Daisy Buchanan, told by his friend Nick Carraway.", imageLinks: ImageLinks(smallThumbnail: "url1", thumbnail: "url1"), categories: ["Fiction", "Classic"])),
            BookItem(id: "2", volumeInfo: VolumeInfo(title: "1984", subtitle: "A dystopian novel", authors: ["George Orwell"], publishedDate: "1949", pageCount: 328, language: "English", description: "A novel about totalitarianism and surveillance.", imageLinks: ImageLinks(smallThumbnail: "url2", thumbnail: "url2"), categories: ["Fiction", "Dystopian"]))
        ]
        return viewModel
    }
}

