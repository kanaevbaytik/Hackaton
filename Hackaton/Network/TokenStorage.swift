//
//  TokenStorage.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation

class TokenStorage {
    static let shared = TokenStorage()
    private init() {}

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    func saveTokens(access: String, refresh: String) {
        UserDefaults.standard.set(access, forKey: accessTokenKey)
        UserDefaults.standard.set(refresh, forKey: refreshTokenKey)
    }

    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }

    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }

    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}
