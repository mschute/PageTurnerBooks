//
//  BookTrackerModel.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import Foundation

struct BookTrackerModel{
    var startDate: Date
    var endDate: Date
    var lastPageRead: Int
    // These two maybe we get through a connection with the bookModel
    var totalPageCount: Int
    var bookTitle: String
    //Maybe get rid of progress variable as its merely calculated
    var progress: Double {
        Double(lastPageRead) / Double(totalPageCount)
    }
    //var userId: String
    //var bookId: String
}
