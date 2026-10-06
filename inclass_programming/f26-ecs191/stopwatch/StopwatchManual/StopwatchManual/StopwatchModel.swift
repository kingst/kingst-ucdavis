//
//  StopwatchModel.swift
//  StopwatchManual
//
//  Created by Sam King on 9/29/26.
//

import Combine
import Foundation
import SwiftUI

/// Combined model and view model for the stopwatch. The view reads the
/// published fields and calls the button press functions in response
/// to UI events.
class StopwatchModel: ObservableObject {
    enum Mode {
        case running
        case stopped
    }

    private(set) var mode: Mode = .stopped

    @Published private(set) var durationHours = 0
    @Published private(set) var durationMinutes = 0
    @Published private(set) var durationSeconds = 0

    @Published private(set) var startStopButtonText = "start"
    @Published private(set) var startStopButtonColor = Color.green
    @Published private(set) var lapResetButtonText = "reset"

    /// One string per completed lap in the current session, newest first.
    @Published private(set) var laps: [String] = []

    /// Where the model gets the current time. Tests can pass in a fake clock.
    private let now: () -> Date
    private var updateTask: Task<Void, Never>?

    /// Elapsed time from earlier runs, before the most recent start.
    private var accumulatedTime: TimeInterval = 0
    /// When the stopwatch was last started, nil while stopped.
    private var startTime: Date?
    /// Elapsed time when the current lap began.
    private var lapStartTime: TimeInterval = 0

    init(now: @escaping () -> Date = Date.init) {
        self.now = now
    }

    private var elapsedTime: TimeInterval {
        guard let startTime else { return accumulatedTime }
        return accumulatedTime + now().timeIntervalSince(startTime)
    }

    func startStopButtonPress() {
        switch mode {
        case .stopped: start()
        case .running: stop()
        }
    }

    func lapResetButtonPress() {
        switch mode {
        case .running: lap()
        case .stopped: reset()
        }
    }

    /// Recomputes the published duration from the elapsed time. The
    /// update task calls this several times per second while running.
    func updateDuration() {
        let (hours, minutes, seconds) = Self.components(of: elapsedTime)
        durationHours = hours
        durationMinutes = minutes
        durationSeconds = seconds
    }

    private func start() {
        startTime = now()
        mode = .running
        startStopButtonText = "stop"
        startStopButtonColor = .red
        lapResetButtonText = "lap"

        updateTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                guard let self else { return }
                self.updateDuration()
            }
        }
    }

    private func stop() {
        accumulatedTime = elapsedTime
        startTime = nil
        updateTask?.cancel()
        updateTask = nil
        mode = .stopped
        updateDuration()
        startStopButtonText = "start"
        startStopButtonColor = .green
        lapResetButtonText = "reset"
    }

    private func lap() {
        let elapsed = elapsedTime
        let lapNumber = laps.count + 1
        laps.insert("Lap \(lapNumber): \(Self.format(elapsed - lapStartTime))", at: 0)
        lapStartTime = elapsed
    }

    private func reset() {
        accumulatedTime = 0
        lapStartTime = 0
        laps = []
        updateDuration()
    }

    /// Formats a duration as HH:MM.SS, so 1 hour 14 minutes 3 seconds
    /// is "01:14.03".
    static func format(hours: Int, minutes: Int, seconds: Int) -> String {
        String(format: "%02d:%02d.%02d", hours, minutes, seconds)
    }

    private static func format(_ interval: TimeInterval) -> String {
        let (hours, minutes, seconds) = components(of: interval)
        return format(hours: hours, minutes: minutes, seconds: seconds)
    }

    private static func components(of interval: TimeInterval) -> (hours: Int, minutes: Int, seconds: Int) {
        let totalSeconds = Int(interval)
        return (totalSeconds / 3600, (totalSeconds / 60) % 60, totalSeconds % 60)
    }
}
