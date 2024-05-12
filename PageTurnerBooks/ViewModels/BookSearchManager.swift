//
//  BookSearchManager.swift
//
//  Construct URL and makes API calls. Not for direct use by UI.

import Foundation

class BookSearchManager {
    enum SearchType {
        case barcode
        case searchBar
    }
    
    func getBookInfo(query: String, searchType: SearchType, completion: @escaping (Books?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // Use guard to ensure the base URL is valid
        guard let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes") else {
            print("Invalid base URL")
            completion(nil) // Ensure to call completion with nil in case of an error
            return
        }
        
        var queryParams = [String: String]()
        
        // Determine the query parameters based on the search type
        switch searchType {
        case .barcode:
            queryParams["q"] = "isbn:\(query)"
            print ("Querying ISBN:" + query)
        case .searchBar:
            queryParams["q"] = "intitle:\(query)"
        }
        
        // Append query parameters using the extension
        let url = baseURL.appendingQueryParameters(queryParams)
        
        // Create a URLRequest using the constructed URL
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("Request URL is: \(request.url?.absoluteString ?? "Invalid URL")")
        
        // Create and resume a URLSession data task
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("URL Session Task Failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response or HTTP status code not 200")
                completion(nil)
                return
            }
            
            // Attempt to parse the JSON data returned from the API
            guard let jsonData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let bookData = try JSONDecoder().decode(Books.self, from: jsonData)
                print("Successfully decoded JSON into Books model.")
                print("Decoded book data: \(bookData)")
                print("Preparing to return data...")
                completion(bookData)
            } catch {
                print("Error parsing JSON: \(error)")
                if let jsonDataString = String(data: jsonData, encoding: .utf8) {
                    print("JSON Data Received: \(jsonDataString)")
                }
                completion(nil)
            }
        }
        
        task.resume()  // This should be outside the closure
    }
}

