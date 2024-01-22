//
//  SettingsView.swift
//  GrandmaGotHitBySomething
//
//  Created by Sam King on 1/22/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    let colors: [Color] = [.black, .red, .green, .blue]
    var body: some View {
        Form {
            Toggle("Super mode", isOn: .constant(true))
            Text("Some text")
            Picker("Font color", selection: $settingsViewModel.textColor) {
                Text("Black").foregroundStyle(.black).tag(Color.black)
                Text("Red").foregroundStyle(.red).tag(Color.red)
                Text("Green").foregroundStyle(.green).tag(Color.green)
                Text("Blue").foregroundStyle(.blue).tag(Color.blue)
            }
            .pickerStyle(.inline)
            .onChange(of: settingsViewModel.textColor) {
                dismiss()
            }
        }
    }
}

#Preview {
    SettingsView()
}
