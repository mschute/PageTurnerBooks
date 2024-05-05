import SwiftUI
import AVFoundation

protocol CoordinatorDelegate: AnyObject {
    func didRetrieveBooks(_ bookItems: [BookItem])
}

enum SearchSource {
    case scanner
    case searchBar
}

class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: CoordinatorDelegate?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            print("Scanned barcode: \(stringValue)")
            if isValidISBN(stringValue) {
                print("Valid ISBN extracted: \(stringValue)")
                searchBooks(stringValue, source: .scanner)
            } else {
                print("Invalid or no ISBN found in barcode")
            }
        }
    }
    
    /// Checks if the extracted string is a valid ISBN.
    func isValidISBN(_ isbn: String) -> Bool {
        let strippedISBN = isbn.filter("0123456789".contains)
        print("Stripped ISBN: \(strippedISBN)")  // Additional logging
        let isValid = strippedISBN.count == 10 || strippedISBN.count == 13
        print("Is ISBN Valid: \(isValid)")  // Log validity check result
        return isValid
    }
    
    
    /// Searches for books based on the query provided which should be an ISBN.
    func searchBooks(_ query: String, source: SearchSource) {
        let searchType = (source == .scanner) ? BookSearchManager.SearchType.barcode : BookSearchManager.SearchType.searchBar
        print("Starting book search with query: \(query), searchType: \(searchType)")
        
        BookSearchManager().getBookInfo(query: query, searchType: searchType) { bookData in
            DispatchQueue.main.async {
                if let books = bookData {
                    print("Fetched \(books.items.count) books successfully.")
                    self.delegate?.didRetrieveBooks(books.items)
                    print("Data passed to delegate.")
                } else {
                    print("Failed to fetch book data or no data available")
                }
            }
        }
    }
}


