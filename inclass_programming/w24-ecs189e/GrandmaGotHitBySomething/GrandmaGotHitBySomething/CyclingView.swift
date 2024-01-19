//
//  CyclingView.swift
//  GrandmaGotHitBySomething
//
//  Created by Sam King on 1/19/24.
//

import SwiftUI

struct CyclingView: View {
    @Binding var rootViewType: RootViewType
    var body: some View {
        VStack {
            Text("Grandma got hit by a bike view")
            Spacer()
            RootSelectionView(rootViewType: $rootViewType)
        }
        .padding()
    }
}

#Preview {
    CyclingView(rootViewType: .constant(.cyclingView))
}
