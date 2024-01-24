//
//  CyclingView.swift
//  GrandmaGotHitBySomething
//
//  Created by Sam King on 1/19/24.
//

import SwiftUI

struct CyclingView: View {
    @Binding var rootViewType: RootViewType
    @EnvironmentObject var viewModel: SettingsViewModel
    @State var showSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "gear")
                }
            }
            Text("Grandma got hit by a bike view")
                .foregroundStyle(viewModel.textColor)
            Spacer()
            RootSelectionView(rootViewType: $rootViewType)
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            SettingsView(isInNavigationStack: false)
        }
    }
}

#Preview {
    CyclingView(rootViewType: .constant(.cyclingView))
        .environmentObject(SettingsViewModel())
}
