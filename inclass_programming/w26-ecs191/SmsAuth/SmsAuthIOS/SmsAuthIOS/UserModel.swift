//
//  UserModel.swift
//  SmsAuthIOS
//
//  Created by Sam King on 1/15/26.
//

import Foundation

struct UserModel {
    private static let tokenKey = "auth_token"
    private static let userIdKey = "user_id"
    private static let baseURL = "https://ecs191-sms-authentication.uc.r.appspot.com"
    private static let appId = "app_id_smsauthios"

    // Use ephemeral session on simulator to avoid QUIC protocol issues with App Engine
    private static let urlSession: URLSession = {
        #if targetEnvironment(simulator)
        let config = URLSessionConfiguration.ephemeral

        // FORCE HTTP/1.1
        // This prevents HTTP/2 and HTTP/3 upgrades entirely.
        // It is slower, but rock-solid stable for the Simulator.
        config.httpMaximumConnectionsPerHost = 1

        return URLSession(configuration: config)
        #else
        return URLSession.shared
        #endif
    }()

    // MARK: - Token Persistence

    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    static func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }

    // MARK: - User ID Persistence

    static func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }

    static func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }

    static func deleteUserId() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }

    // MARK: - API Calls

    static func sendSmsCode(phoneNumber: String) async throws {
        let url = URL(string: "\(baseURL)/v1/send_sms_code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "phone_number": phoneNumber,
            "app_id": appId
        ]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserModelError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw UserModelError.serverError(errorResponse.error)
            }
            throw UserModelError.serverError("Request failed with status \(httpResponse.statusCode)")
        }
    }

    static func verifyCode(phoneNumber: String, code: String) async throws -> VerifyCodeResponse {
        let url = URL(string: "\(baseURL)/v1/verify_code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "phone_number": phoneNumber,
            "app_id": appId,
            "code": code
        ]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserModelError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw UserModelError.serverError(errorResponse.error)
            }
            throw UserModelError.serverError("Request failed with status \(httpResponse.statusCode)")
        }

        let verifyResponse = try JSONDecoder().decode(VerifyCodeResponse.self, from: data)
        return verifyResponse
    }

    static func getUser() async throws -> UserResponse {
        guard let token = getToken() else {
            throw UserModelError.notAuthenticated
        }

        let url = URL(string: "\(baseURL)/v1/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserModelError.invalidResponse
        }

        if httpResponse.statusCode == 401 {
            throw UserModelError.invalidToken
        }

        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw UserModelError.serverError(errorResponse.error)
            }
            throw UserModelError.serverError("Request failed with status \(httpResponse.statusCode)")
        }

        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return userResponse
    }
}

// MARK: - Response Types

struct VerifyCodeResponse: Codable {
    let success: Bool
    let token: String
    let user_id: String
}

struct UserResponse: Codable {
    let user_id: String
    let created_at: String
}

struct ErrorResponse: Codable {
    let error: String
}

// MARK: - Errors

enum UserModelError: LocalizedError {
    case invalidResponse
    case serverError(String)
    case notAuthenticated
    case invalidToken

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let message):
            return message
        case .notAuthenticated:
            return "Not authenticated"
        case .invalidToken:
            return "Invalid or expired token"
        }
    }
}
