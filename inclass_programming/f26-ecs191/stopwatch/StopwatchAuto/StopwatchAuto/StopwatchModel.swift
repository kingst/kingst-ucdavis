//
//  StopwatchModel.swift
//  StopwatchAuto
//

import Foundation
import Observation

/// A stopwatch's state, kept as timestamps rather than a running count so
/// the elapsed time stays correct no matter how often, or whether, the app
/// gets to run.
///
/// Times handed to the view are whole hundredths of a second, the precision
/// the stopwatch shows. Lap boundaries are recorded in that same unit, so the
/// laps on screen always add up exactly to the total on screen.
struct StopwatchState: Codable, Equatable {
    /// Seconds from earlier runs that ended with Stop.
    private(set) var accumulated: TimeInterval = 0
    /// When the current run started, or nil while stopped.
    private(set) var runningSince: Date?
    /// The elapsed time, in hundredths, at each press of Lap, oldest first.
    private(set) var lapSplits: [Int] = []

    var isRunning: Bool { runningSince != nil }

    /// True before the first Start and after Reset.
    var isReset: Bool { !isRunning && accumulated == 0 }

    /// Total elapsed time at `date`, in hundredths of a second.
    func elapsed(at date: Date) -> Int {
        var seconds = accumulated
        if let runningSince {
            // max guards against the clock being set backwards.
            seconds += max(0, date.timeIntervalSince(runningSince))
        }
        return Int((seconds * 100).rounded(.down))
    }

    /// Durations of the finished laps, oldest first.
    var completedLaps: [Int] {
        zip(lapSplits, [0] + lapSplits).map { split, previousSplit in
            split - previousSplit
        }
    }

    /// Duration of the lap in progress at `date`. It keeps counting across a
    /// Stop and Start, just like the total.
    func currentLap(at date: Date) -> Int {
        max(0, elapsed(at: date) - (lapSplits.last ?? 0))
    }

    /// Indices into `completedLaps` of the fastest and slowest laps, once
    /// there are at least two finished laps that aren't all the same.
    var fastestAndSlowestLap: (fastest: Int, slowest: Int)? {
        let laps = completedLaps
        guard laps.count >= 2,
              let fastest = laps.indices.min(by: { laps[$0] < laps[$1] }),
              let slowest = laps.indices.max(by: { laps[$0] < laps[$1] }),
              laps[fastest] < laps[slowest] else {
            return nil
        }
        return (fastest, slowest)
    }

    mutating func start(at date: Date) {
        guard !isRunning else { return }
        runningSince = date
    }

    mutating func stop(at date: Date) {
        guard let runningSince else { return }
        accumulated += max(0, date.timeIntervalSince(runningSince))
        self.runningSince = nil
    }

    mutating func lap(at date: Date) {
        guard isRunning else { return }
        lapSplits.append(elapsed(at: date))
    }

    mutating func reset() {
        guard !isRunning else { return }
        self = StopwatchState()
    }
}

/// Owns the stopwatch state for the UI, turns button presses into state
/// changes, and saves every change so the stopwatch picks up where it left
/// off if iOS kills the app.
@Observable
final class StopwatchModel {
    private(set) var state: StopwatchState

    private let defaults: UserDefaults
    private static let stateKey = "stopwatchState"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.stateKey),
           let saved = try? JSONDecoder().decode(StopwatchState.self, from: data) {
            state = saved
        } else {
            state = StopwatchState()
        }
    }

    /// Starts when stopped, stops when running.
    func startStopPressed() {
        let now = Date.now
        if state.isRunning {
            state.stop(at: now)
        } else {
            state.start(at: now)
        }
        save()
    }

    /// Starts a new lap when running, resets when stopped.
    func lapResetPressed() {
        if state.isRunning {
            state.lap(at: .now)
        } else {
            state.reset()
        }
        save()
    }

    /// The state only changes on a button press, since the running time is
    /// worked out from timestamps, so there's nothing extra to save when the
    /// app goes to the background.
    private func save() {
        if let data = try? JSONEncoder().encode(state) {
            defaults.set(data, forKey: Self.stateKey)
        }
    }
}
