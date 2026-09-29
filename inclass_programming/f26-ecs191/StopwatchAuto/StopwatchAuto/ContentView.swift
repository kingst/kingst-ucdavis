//
//  ContentView.swift
//  StopwatchAuto
//
//  Created by Sam King on 9/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var stopwatch = StopwatchModel()

    var body: some View {
        let state = stopwatch.state
        // Redraws every frame while running; the time itself comes from the
        // model's timestamps, so a missed frame never loses time. A single
        // timeline drives both the total and the current lap so they're
        // always computed from the same instant.
        TimelineView(.animation(minimumInterval: 0.01, paused: !state.isRunning)) { context in
            VStack(spacing: 0) {
                Text(stopwatchText(state.elapsed(at: context.date)))
                    .font(.system(size: 90, weight: .thin))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxHeight: .infinity)

                HStack {
                    lapResetButton(state)
                    Spacer()
                    startStopButton(state)
                }
                .padding(.bottom, 16)

                Divider()

                LapList(state: state, now: context.date)
                    .frame(maxHeight: .infinity)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.systemBackground))
    }

    private func lapResetButton(_ state: StopwatchState) -> some View {
        let isReset = state.isReset
        return Button(state.isRunning || isReset ? "Lap" : "Reset") {
            stopwatch.lapResetPressed()
        }
        .buttonStyle(CircleButtonStyle(
            foreground: isReset ? .secondary : .primary,
            fill: Color(isReset ? .systemGray6 : .systemGray5)))
        .disabled(isReset)
    }

    private func startStopButton(_ state: StopwatchState) -> some View {
        let tint: Color = state.isRunning ? .red : .green
        return Button(state.isRunning ? "Stop" : "Start") {
            stopwatch.startStopPressed()
        }
        .buttonStyle(CircleButtonStyle(foreground: tint, fill: tint.opacity(0.25)))
    }
}

/// The laps, newest first, with the lap in progress on top.
private struct LapList: View {
    let state: StopwatchState
    let now: Date

    var body: some View {
        let laps = state.completedLaps
        let extremes = state.fastestAndSlowestLap
        ScrollView {
            LazyVStack(spacing: 0) {
                if !state.isReset {
                    LapRow(number: laps.count + 1,
                           duration: state.currentLap(at: now),
                           color: .primary)
                    Divider()
                }
                ForEach(laps.indices.reversed(), id: \.self) { index in
                    LapRow(number: index + 1,
                           duration: laps[index],
                           color: index == extremes?.fastest ? .green
                                : index == extremes?.slowest ? .red
                                : .primary)
                    Divider()
                }
            }
        }
    }
}

private struct LapRow: View {
    let number: Int
    let duration: Int
    let color: Color

    var body: some View {
        HStack {
            Text("Lap \(number)")
            Spacer()
            Text(stopwatchText(duration))
                .monospacedDigit()
        }
        .foregroundStyle(color)
        .padding(.vertical, 12)
    }
}

/// The round Start / Stop / Lap / Reset buttons, with the thin inner ring
/// the iOS stopwatch uses.
private struct CircleButtonStyle: ButtonStyle {
    let foreground: Color
    let fill: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundStyle(foreground)
            .frame(width: 84, height: 84)
            .background {
                Circle().fill(fill)
                Circle()
                    .strokeBorder(Color(.systemBackground), lineWidth: 2)
                    .padding(3)
            }
            .contentShape(Circle())
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

/// Formats hundredths of a second as mm:ss.hh, adding hours once needed.
private func stopwatchText(_ hundredths: Int) -> String {
    let fraction = hundredths % 100
    let totalSeconds = hundredths / 100
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60 % 60
    let hours = totalSeconds / 3600
    if hours > 0 {
        return String(format: "%d:%02d:%02d.%02d", hours, minutes, seconds, fraction)
    }
    return String(format: "%02d:%02d.%02d", minutes, seconds, fraction)
}

#Preview {
    ContentView()
}
