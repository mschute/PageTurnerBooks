//
//  BookTrackerModel.swift

import Foundation

struct BookTrackerModel: Codable, Identifiable {
    var id: String
    var userId: String
    var startDate: Date
    var endDate: Date?
    var lastPageRead: Int
    var totalPageCount: Int
    var bookTitle: String
    
    init(id: String, userId: String, startDate: Date, endDate: Date?, lastPageRead: Int, totalPageCount: Int, bookTitle: String) {
        self.id = id
        self.userId = userId
        self.startDate = startDate
        self.endDate = endDate
        self.lastPageRead = lastPageRead
        self.totalPageCount = totalPageCount
        self.bookTitle = bookTitle
    }
    
    static var mock: BookTrackerModel {
        return BookTrackerModel(id: "testID", userId: "9laC5umqf4T6fviudjD6HcuN1pW2", startDate: Date(), endDate: nil, lastPageRead: 50, totalPageCount: 300, bookTitle: "Harry Potter and the Sorcerer's Stone")
    }
}




