//
//  MainView.swift
//  StopwatchManual
//
//  Created by Sam King on 9/29/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var model = StopwatchModel()

    var body: some View {
        VStack(spacing: 32) {
            duration
                .padding(.top, 64)
            HStack {
                lapResetButton
                Spacer()
                startStopButton
            }
            .padding(.horizontal)
            lapList
        }
        .padding()
    }

    private var duration: some View {
        Text(StopwatchModel.format(hours: model.durationHours,
                                   minutes: model.durationMinutes,
                                   seconds: model.durationSeconds))
            .font(.system(size: 80, weight: .thin))
            .monospacedDigit()
            .accessibilityIdentifier("duration")
    }

    private var startStopButton: some View {
        circleButton(model.startStopButtonText, color: model.startStopButtonColor) {
            model.startStopButtonPress()
        }
        .accessibilityIdentifier("startStopButton")
    }

    private var lapResetButton: some View {
        circleButton(model.lapResetButtonText, color: .gray) {
            model.lapResetButtonPress()
        }
        .accessibilityIdentifier("lapResetButton")
    }

    private var lapList: some View {
        List(model.laps, id: \.self) { lap in
            Text(lap)
                .monospacedDigit()
        }
        .listStyle(.plain)
        .accessibilityIdentifier("lapList")
    }

    private func circleButton(_ title: String, color: Color,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .frame(width: 88, height: 88)
                .foregroundStyle(color)
                .background(color.opacity(0.25), in: Circle())
        }
    }
}

#Preview {
    MainView()
}
