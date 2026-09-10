//
//  APIClient.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Int)
    case decodingFailed
    case unauthorized
}

actor APIClient {
    static let shared = APIClient()
    private init() {}
    
    func request<T: Decodable, U: Encodable>(
        url stringURL: String,
        method: String = "GET",
        body: U? = nil,
        token: String? = nil,
        additionalHeaders: [String: String]? = nil
    ) async throws -> T {
        guard let url = URL(string: stringURL) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let additionalHeaders = additionalHeaders {
            for (key, value) in additionalHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(0)
        }

        print("🌐 HTTP STATUS:", httpResponse.statusCode)

        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ HTTP ERROR RESPONSE:")
            print(String(data: data, encoding: .utf8) ?? "Unable to read response")

            throw APIError.requestFailed(httpResponse.statusCode)
        }

        if T.self == EmptyResponse.self {
            return EmptyResponse() as! T
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ DECODING ERROR:")
            print(error)

            print("📦 RAW RESPONSE:")
            print(String(data: data, encoding: .utf8) ?? "Unable to read response")

            throw APIError.decodingFailed
        }
    }
    
    func request<T: Decodable>(
        url: String,
        method: String = "GET",
        token: String? = nil,
        additionalHeaders: [String: String]? = nil 
    ) async throws -> T {
        return try await request(
            url: url,
            method: method,
            body: [String: String]?.none,
            token: token,
            additionalHeaders: additionalHeaders
        )
    }
}
