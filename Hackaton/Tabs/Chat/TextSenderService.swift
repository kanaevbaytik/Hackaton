//
//  TextSenderService.swift
//  Hackaton
//
//  Created by Baytik  on 25/5/25.
//

import Foundation

final class TextSenderService {

    static let shared = TextSenderService()

    private init() {}

    func send(text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://192.168.0.168:5000/tts") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["text": text]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Serialization error", code: 0)))
            return
        }

        // ⚠️ Работа на главном потоке (НЕ РЕКОМЕНДУЕТСЯ в боевых проектах!)
        URLSession.shared.uploadTask(with: request, from: jsonData) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "Server error", code: 0)))
                    return
                }

                completion(.success(()))
            }
        }.resume()
    }
}
