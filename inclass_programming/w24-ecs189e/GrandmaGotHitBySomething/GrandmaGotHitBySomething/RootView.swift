//
//  ContentView.swift
//  GrandmaGotHitBySomething
//
//  Created by Sam King on 1/19/24.
//

import SwiftUI

enum RootViewType {
    case timerView
    case cyclingView
}

struct RootView: View {
    @State var rootViewType: RootViewType = .timerView
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        switch rootViewType {
        case .timerView:
            NavigationStack {
                TimerView(rootViewType: $rootViewType)
            }
            .environmentObject(settingsViewModel)
        case .cyclingView:
            CyclingView(rootViewType: $rootViewType)
                .environmentObject(settingsViewModel)
        }
    }
}

#Preview {
    RootView()
}
