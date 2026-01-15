//
//  UserService.swift
//  SmsAuthIOS
//
//  Created by Sam King on 1/15/26.
//

import Foundation

enum UserState {
    case initializing
    case enterPhoneNumber
    case verifyCode
    case loggedIn
}

@MainActor
class UserService: ObservableObject {
    @Published var userState: UserState = .initializing
    @Published var isAuthenticated: Bool = false
    @Published var userId: String?
    @Published var authError: String?
    @Published var isLoading: Bool = false

    // Store phone number for use in verify code view
    @Published var phoneNumber: String = ""

    init() {
        Task {
            await checkExistingSession()
        }
    }

    private func checkExistingSession() async {
        guard UserModel.getToken() != nil else {
            userState = .enterPhoneNumber
            return
        }

        do {
            let userResponse = try await UserModel.getUser()
            userId = userResponse.user_id
            isAuthenticated = true
            userState = .loggedIn
        } catch {
            // Token is invalid, clear it and go to phone entry
            UserModel.deleteToken()
            UserModel.deleteUserId()
            userState = .enterPhoneNumber
        }
    }

    func sendVerificationCode(phoneNumber: String) async {
        isLoading = true
        authError = nil

        do {
            try await UserModel.sendSmsCode(phoneNumber: phoneNumber)
            self.phoneNumber = phoneNumber
            userState = .verifyCode
        } catch {
            authError = error.localizedDescription
        }

        isLoading = false
    }

    func verifyCode(code: String) async {
        isLoading = true
        authError = nil

        do {
            let response = try await UserModel.verifyCode(phoneNumber: phoneNumber, code: code)
            UserModel.saveToken(response.token)
            UserModel.saveUserId(response.user_id)
            userId = response.user_id
            isAuthenticated = true
            userState = .loggedIn
        } catch {
            authError = error.localizedDescription
        }

        isLoading = false
    }

    func logout() {
        UserModel.deleteToken()
        UserModel.deleteUserId()
        userId = nil
        isAuthenticated = false
        phoneNumber = ""
        authError = nil
        userState = .enterPhoneNumber
    }

    func clearAuthError() {
        authError = nil
    }

    func goBackToPhoneEntry() {
        authError = nil
        userState = .enterPhoneNumber
    }
}
