//
//  EmojiChatApp.swift
//  EmojiChat
//
//  Created by Sam King on 1/10/24.
//

import SwiftUI

@main
struct EmojiChatApp: App {
    @StateObject var messagesViewModel = MessageViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainChatView()
                .environmentObject(messagesViewModel)
        }
    }
}
