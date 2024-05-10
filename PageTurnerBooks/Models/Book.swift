//
//  Book.swift

import Foundation

struct Books: Decodable {
    var items: [BookItem]
}

struct BookItem: Decodable, Identifiable
{
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publishedDate: String?
    let pageCount: Int?
    let language: String?
    let description: String?
    let imageLinks: ImageLinks?
    let categories: [String]?
}

struct ImageLinks: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}

