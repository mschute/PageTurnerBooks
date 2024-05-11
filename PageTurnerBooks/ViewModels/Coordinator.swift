//
// Coordinator.swift

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
    var onBookRetrieved: (() -> Void)?

    override init() {
        super.init()
        self.captureSession = AVCaptureSession()
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            print("Scanned barcode: \(stringValue)")
            if let validISBN = extractValidISBN(from: stringValue) {
                print("Valid ISBN extracted: \(validISBN)")
                searchBooks(validISBN, source: .scanner)
            } else {
                print("Invalid or no ISBN found in barcode")
            }
        }
    }

    func extractValidISBN(from string: String) -> String? {
        let regex = try! NSRegularExpression(pattern: "\\d+")
        let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
        
        for match in results {
            if let range = Range(match.range, in: string) {
                let sequence = String(string[range])
                if sequence.count == 10 || sequence.count == 13 {
                    return sequence
                }
            }
        }
        return nil
    }

    func searchBooks(_ query: String, source: SearchSource) {
        let searchType = (source == .scanner) ? BookSearchManager.SearchType.barcode : BookSearchManager.SearchType.searchBar
        BookSearchManager().getBookInfo(query: query, searchType: searchType) { bookData in
            DispatchQueue.main.async {
                if let books = bookData {
                    self.delegate?.didRetrieveBooks(books.items)
                    self.onBookRetrieved?()
                } else {
                    print("Failed to fetch book data or no data available")
                }
            }
        }
    }

    func startSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)

            let metadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(metadataOutput)

            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            videoPreviewLayer?.session = captureSession
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = UIScreen.main.bounds

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.startRunning()
            }
        } catch {
            print("Error starting the camera: \(error)")
        }
    }
}
