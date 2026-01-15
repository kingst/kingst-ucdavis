//
//  VerifyCodeView.swift
//  SmsAuthIOS
//
//  Created by Sam King on 1/15/26.
//

import SwiftUI
import PhoneNumberKit

struct VerifyCodeView: View {
    @EnvironmentObject var userService: UserService
    @State private var code: String = ""
    @FocusState private var isCodeFieldFocused: Bool

    private let phoneNumberUtility = PhoneNumberUtility()

    private var formattedPhoneNumber: String {
        do {
            let parsed = try phoneNumberUtility.parse(userService.phoneNumber)
            return phoneNumberUtility.format(parsed, toType: .national)
        } catch {
            return userService.phoneNumber
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            HStack {
                Button {
                    userService.goBackToPhoneEntry()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)

            Text("What's the code?")
                .font(.title)
                .fontWeight(.bold)

            Text("Enter the code we sent to \(formattedPhoneNumber)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            TextField("000000", text: $code)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 40)
                .focused($isCodeFieldFocused)
                .onChange(of: code) { oldValue, newValue in
                    // Only allow digits and limit to 6 characters
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count <= 6 {
                        code = filtered
                    } else {
                        code = String(filtered.prefix(6))
                    }

                    userService.clearAuthError()

                    // Auto-submit when 6 digits entered
                    if code.count == 6 {
                        Task {
                            await userService.verifyCode(code: code)
                        }
                    }
                }

            if userService.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }

            if let error = userService.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            isCodeFieldFocused = true
        }
    }
}

#Preview {
    let userService = UserService()
    return VerifyCodeView()
        .environmentObject(userService)
}
