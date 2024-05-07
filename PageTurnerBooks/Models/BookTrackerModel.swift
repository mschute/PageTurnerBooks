//
//  BookTrackerModel.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import Foundation

struct BookTrackerModel: Codable, Identifiable {
    var id: String // Usually same as the bookId for uniqueness per user
    var userId: String
    var startDate: Date
    var endDate: Date?
    var lastPageRead: Int
    var totalPageCount: Int
    var bookTitle: String
}
