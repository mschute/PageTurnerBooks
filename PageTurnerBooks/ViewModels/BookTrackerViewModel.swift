//
//  BookTrackerViewModel.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class BookTrackerViewModel: ObservableObject {
    @Published var tracker: BookTrackerModel
    private var db = Firestore.firestore()
    private var userId: String
    
    init(userId: String, tracker: BookTrackerModel) {
            self.userId = userId
            self.tracker = tracker
        }

    func updateTracking(bookId: String, tracking: BookTrackerModel) {
        // This should be the correct path to nest the tracking document inside the book document
        let trackingRef = db.collection("Users").document(userId)
                             .collection("CurrentlyReading").document(bookId)
                             .collection("tracking").document("trackingData") // Changed to a fixed document name for tracking

        print("Updating tracking at path: \(trackingRef.path)")

        do {
            try trackingRef.setData(from: tracking, merge: true) { error in
                if let error = error {
                    print("Error updating tracking: \(error.localizedDescription)")
                } else {
                    print("Tracking data successfully updated for bookId: \(bookId) at \(trackingRef.path)")
                }
            }
        } catch let serializationError {
            print("Error serializing tracking data: \(serializationError.localizedDescription)")
        }
    }
    
    // Function to update the last page read
        func updateLastPageRead(bookId: String, lastPage: Int) {
            let trackingRef = db.collection("Users").document(userId)
                                 .collection("CurrentlyReading").document(bookId)
                                 .collection("tracking").document("trackingData")

            trackingRef.updateData(["lastPageRead": lastPage]) { error in
                if let error = error {
                    print("Error updating last page read: \(error.localizedDescription)")
                } else {
                    print("Last page read successfully updated for bookId: \(bookId)")
                    DispatchQueue.main.async {
                        self.tracker.lastPageRead = lastPage
                    }
                }
            }
        }


    // Function to fetch tracking data
    func fetchTracking() {
        let trackingRef = db.collection("Users").document(userId)
                             .collection("CurrentlyReading").document(tracker.id)
                             .collection("tracking").document("trackingData")

        trackingRef.getDocument { document, error in
            if let document = document, let trackingData = try? document.data(as: BookTrackerModel.self) {
                DispatchQueue.main.async {
                    self.tracker = trackingData
                }
            } else {
                print("Error fetching tracking data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
