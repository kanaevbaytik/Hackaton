//
//  NetworkError.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    case unknown
}
