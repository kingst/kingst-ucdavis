//
//  ContentView.swift
//  EmojiChat
//
//  Created by Sam King on 1/10/24.
//

import SwiftUI

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
}

struct Message: Identifiable {
    let text: String
    let id = UUID().uuidString
}

struct MainChatView: View {
    @State var messages: [Message] = []
    //@EnvironmentObject var messagesViewModel: MessageViewModel
    
    var body: some View {
        let emojis = ["😎", "😘", "👍", "🖕"]
        VStack {
            Text("Emoji Chat")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(.white)
            ForEach(messages) { message in
                Text(message.text)
            }
            Spacer()
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    EmojiButtonView(messages: $messages, emoji: emoji)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        //.frame(width: 250)
        .background(.blue.opacity(0.5))
    }
}

struct EmojiButtonView: View {
    @Binding var messages: [Message]
    let emoji: String
    
    var body: some View {
        Button {
            messages.append(Message(text: emoji))
        } label: {
            Text(emoji)
                .font(.largeTitle)
        }
    }
}

#Preview {
    MainChatView()
}
