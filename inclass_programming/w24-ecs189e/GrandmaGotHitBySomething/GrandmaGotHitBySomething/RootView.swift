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
    
    var body: some View {
        switch rootViewType {
        case .timerView:
            TimerView(rootViewType: $rootViewType)
        case .cyclingView:
            CyclingView(rootViewType: $rootViewType)
        }
    }
}

#Preview {
    RootView()
}
