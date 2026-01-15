//
//  EnterPhoneNumberView.swift
//  SmsAuthIOS
//
//  Created by Sam King on 1/15/26.
//

import SwiftUI
import PhoneNumberKit

struct CountryInfo: Identifiable, Hashable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let regionCode: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CountryInfo, rhs: CountryInfo) -> Bool {
        lhs.id == rhs.id
    }
}

struct EnterPhoneNumberView: View {
    @EnvironmentObject var userService: UserService

    @State private var phoneNumberText: String = ""
    @State private var selectedCountry: CountryInfo

    private let phoneNumberUtility = PhoneNumberUtility()

    private let countries: [CountryInfo] = [
        CountryInfo(id: "US", name: "United States", flag: "🇺🇸", code: "+1", regionCode: "US"),
        CountryInfo(id: "CA", name: "Canada", flag: "🇨🇦", code: "+1", regionCode: "CA"),
        CountryInfo(id: "MX", name: "Mexico", flag: "🇲🇽", code: "+52", regionCode: "MX"),
        CountryInfo(id: "IN", name: "India", flag: "🇮🇳", code: "+91", regionCode: "IN"),
        CountryInfo(id: "CN", name: "China", flag: "🇨🇳", code: "+86", regionCode: "CN")
    ]

    init() {
        let defaultCountry = CountryInfo(id: "US", name: "United States", flag: "🇺🇸", code: "+1", regionCode: "US")
        _selectedCountry = State(initialValue: defaultCountry)
    }

    private var formattedPhoneNumber: String {
        guard !phoneNumberText.isEmpty else { return "" }

        let fullNumber = selectedCountry.code + phoneNumberText.filter { $0.isNumber }

        do {
            let parsed = try phoneNumberUtility.parse(fullNumber, withRegion: selectedCountry.regionCode)
            return phoneNumberUtility.format(parsed, toType: .national)
        } catch {
            return phoneNumberText
        }
    }

    private var e164PhoneNumber: String? {
        let fullNumber = selectedCountry.code + phoneNumberText.filter { $0.isNumber }

        do {
            let parsed = try phoneNumberUtility.parse(fullNumber, withRegion: selectedCountry.regionCode)
            return phoneNumberUtility.format(parsed, toType: .e164)
        } catch {
            return nil
        }
    }

    private var isValidPhoneNumber: Bool {
        return e164PhoneNumber != nil
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("What's your phone number?")
                .font(.title)
                .fontWeight(.bold)

            Text("We'll text you a code to verify your phone")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Menu {
                    ForEach(countries) { country in
                        Button {
                            selectedCountry = country
                            userService.clearAuthError()
                        } label: {
                            Text("\(country.flag) \(country.name) (\(country.code))")
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCountry.flag)
                        Text(selectedCountry.code)
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                TextField("Phone number", text: $phoneNumberText)
                    .keyboardType(.phonePad)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: phoneNumberText) { _, _ in
                        userService.clearAuthError()
                    }
            }
            .padding(.horizontal)

            if let error = userService.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            Button {
                if let e164 = e164PhoneNumber {
                    Task {
                        await userService.sendVerificationCode(phoneNumber: e164)
                    }
                }
            } label: {
                if userService.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                } else {
                    Text("Next")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidPhoneNumber ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(!isValidPhoneNumber || userService.isLoading)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    EnterPhoneNumberView()
        .environmentObject(UserService())
}
