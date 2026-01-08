//
//  ContentView.swift
//  Stopwatch
//
//  Created by Sam King on 1/8/26.
//

import SwiftUI

struct MainView: View {
    @State var model = StopwatchModel()

    var body: some View {
        VStack(spacing: 20) {
            TimerDisplay(model: model)
            ControlButtons(model: model)
            Divider()
            LapList(model: model)
        }
        .preferredColorScheme(.dark)
    }
}

struct TimerDisplay: View {
    var model: StopwatchModel

    var body: some View {
        Text("\(model.durationHours):\(model.durationMinutes).\(model.durationSeconds)")
            .font(.system(size: 80, weight: .thin, design: .monospaced))
            .padding(.top, 40)
    }
}

struct ControlButtons: View {
    var model: StopwatchModel

    var body: some View {
        HStack(spacing: 80) {
            StopwatchButton(
                title: model.lapResetButtonText,
                color: .gray,
                action: { model.lapResetButtonPress() }
            )
            StopwatchButton(
                title: model.startStopButtonText,
                color: model.startStopButtonColor,
                action: { model.startStopButtonPress() }
            )
        }
        .padding(.vertical, 20)
    }
}

struct StopwatchButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18))
                .frame(width: 80, height: 80)
                .background(color.opacity(0.3))
                .foregroundColor(color == .gray ? .primary : color)
                .clipShape(Circle())
        }
    }
}

struct LapList: View {
    var model: StopwatchModel

    var body: some View {
        List {
            if model.showCurrentLap {
                LapRow(lapNumber: model.currentLapNumber, time: model.currentLapTime)
            }
            ForEach(Array(model.laps.enumerated()), id: \.offset) { index, lapTime in
                LapRow(lapNumber: model.laps.count - index, time: lapTime)
            }
        }
        .listStyle(.plain)
    }
}

struct LapRow: View {
    let lapNumber: Int
    let time: TimeInterval

    var body: some View {
        HStack {
            Text("Lap \(lapNumber)")
            Spacer()
            Text(formattedTime)
                .font(.system(.body, design: .monospaced))
        }
    }

    private var formattedTime: String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d.%02d", hours, minutes, seconds)
    }
}

#Preview {
    MainView()
}
