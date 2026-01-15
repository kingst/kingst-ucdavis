//
//  MainView.swift
//  SmsAuthIOS
//
//  Created by Sam King on 1/15/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var userService = UserService()

    var body: some View {
        Group {
            switch userService.userState {
            case .initializing:
                ProgressView("Loading...")
            case .enterPhoneNumber:
                EnterPhoneNumberView()
            case .verifyCode:
                VerifyCodeView()
            case .loggedIn:
                HomeView()
            }
        }
        .environmentObject(userService)
    }
}

#Preview {
    MainView()
}
