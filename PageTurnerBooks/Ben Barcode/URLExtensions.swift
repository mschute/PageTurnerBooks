//
//  URLExtensions.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 04/05/2024.
//

import Foundation

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary: URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary: Dictionary<String, String>) -> URL {
        let urlString = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: urlString)!
    }
}
