//
//  HomeView.swift
//  SmsAuthIOS
//
//  Created by Sam King on 1/15/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userService: UserService

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("Welcome!")
                .font(.title)
                .fontWeight(.bold)

            if let userId = userService.userId {
                Text("User ID: \(userId)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button {
                userService.logout()
            } label: {
                Text("Log Out")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
    }
}

#Preview {
    HomeView()
        .environmentObject(UserService())
}
