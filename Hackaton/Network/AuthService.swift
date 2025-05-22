//
//  AuthService.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation


class AuthService {
    static let shared = AuthService()
    private init() {}

    private let baseURL = "https://yourapi.com/api"

    func registerUser(_ data: RegisterRequest) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(data)

        let (responseData, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if httpResponse.statusCode == 200 {
            let authData = try JSONDecoder().decode(AuthResponse.self, from: responseData)
            TokenStorage.shared.saveTokens(access: authData.accessToken, refresh: authData.refreshToken)
            return authData
        } else {
            let errorMessage = String(data: responseData, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(errorMessage)
        }
    }

    func loginUser(_ data: LoginRequest) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(data)

        let (responseData, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if httpResponse.statusCode == 200 {
            let authData = try JSONDecoder().decode(AuthResponse.self, from: responseData)
            TokenStorage.shared.saveTokens(access: authData.accessToken, refresh: authData.refreshToken)
            return authData
        } else {
            let errorMessage = String(data: responseData, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(errorMessage)
        }
    }
}
