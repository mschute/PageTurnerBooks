//
//  BookTrackerViewModel.swift

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

    func updateTracking(bookId: String, tracking: BookTrackerModel, trackingStatus: String) {
        let trackingRef = db.collection("Users").document(userId)
                             .collection(trackingStatus).document(bookId)
                             .collection("tracking").document("trackingData")

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
    
    func updateStartDate(bookId: String, startDate: Date) {
            let trackingRef = db.collection("Users").document(userId)
                                 .collection("CurrentlyReading").document(bookId)
                                 .collection("tracking").document("trackingData")

            trackingRef.updateData(["startDate": startDate]) { error in
                if let error = error {
                    print("Error updating start date: \(error.localizedDescription)")
                } else {
                    print("Start date successfully updated for bookId: \(bookId)")
                    DispatchQueue.main.async {
                        self.tracker.startDate = startDate
                    }
                }
            }
        }
    
    func updateEndDate(bookId: String, endDate: Date) {
        let trackingRef = db.collection("Users").document(userId)
                             .collection("FinishedReading").document(bookId)
                             .collection("tracking").document("trackingData")

        trackingRef.updateData(["endDate": endDate]) { error in
            if let error = error {
                print("Error updating end date: \(error.localizedDescription)")
            } else {
                print("End date successfully updated for bookId: \(bookId)")
                DispatchQueue.main.async {
                    self.tracker.endDate = endDate
                }
            }
        }
    }
    
    // Fetch start and end dates for a book in the Finished Reading list
        func fetchTrackingForFinishedBook(bookId: String, completion: @escaping (Date, Date?) -> Void) {
            let trackingRef = db.collection("Users").document(userId)
                .collection("FinishedReading").document(bookId)
                .collection("tracking").document("trackingData")

            trackingRef.getDocument { document, error in
                if let document = document, document.exists {
                    do {
                        let trackingData = try document.data(as: BookTrackerModel.self)
                        DispatchQueue.main.async {
                            completion(trackingData.startDate, trackingData.endDate)
                        }
                    } catch {
                        print("Error decoding tracking data: \(error)")
                        completion(Date(), nil) // Handle error or provide default/fallback values
                    }
                } else {
                    print("Error fetching tracking data: \(error?.localizedDescription ?? "Unknown error")")
                    completion(Date(), nil) // Handle error or provide default/fallback values
                }
            }
        }
    
}

extension BookTrackerViewModel {
    static var mock: BookTrackerViewModel {
        return BookTrackerViewModel(userId: "testUser", tracker: .mock)
    }
}
