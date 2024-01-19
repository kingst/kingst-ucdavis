//
//  RootSelectionView.swift
//  GrandmaGotHitBySomething
//
//  Created by Sam King on 1/19/24.
//

import SwiftUI

struct RootSelectionView: View {
    @Binding var rootViewType: RootViewType
    var body: some View {
        Picker("", selection: $rootViewType) {
            Image(systemName: "timer")
                .tag(RootViewType.timerView)
            Image(systemName: "bicycle")
                .tag(RootViewType.cyclingView)
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    RootSelectionView(rootViewType: .constant(.cyclingView))
}
