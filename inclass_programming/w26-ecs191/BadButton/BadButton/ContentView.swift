//
//  ContentView.swift
//  BadButton
//
//  Created by Sam King on 1/15/26.
//

import SwiftUI

struct ContentView: View {
    @State private var statusText: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Button("bad button") {
                statusText = ""
                isLoading = true
                sleep(3)
                statusText = "bad button done"
                isLoading = false
            }

            Button("good button") {
                Task {
                    statusText = ""
                    isLoading = true
                    try? await Task.sleep(for: .seconds(3))
                    statusText = "good button done"
                    isLoading = false
                }
            }

            if isLoading {
                ProgressView()
            }

            Text(statusText)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
