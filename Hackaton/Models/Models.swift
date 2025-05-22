//
//  Models.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct UserCredentials: Codable {
    let username: String
    let  password: String
}
