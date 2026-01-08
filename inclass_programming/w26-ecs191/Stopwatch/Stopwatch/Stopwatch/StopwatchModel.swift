//
//  StopwatchModel.swift
//  Stopwatch
//
//  Created by Sam King on 1/8/26.
//

import Foundation
import SwiftUI

@Observable
class StopwatchModel {
    private var elapsedTime: TimeInterval = 0
    private var isRunning: Bool = false
    private var timer: Timer?
    private var startTime: Date?
    private var lapStartTime: TimeInterval = 0

    var laps: [TimeInterval] = []

    var durationHours: String {
        let hours = Int(elapsedTime) / 3600
        return String(format: "%02d", hours)
    }

    var durationMinutes: String {
        let minutes = (Int(elapsedTime) % 3600) / 60
        return String(format: "%02d", minutes)
    }

    var durationSeconds: String {
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d", seconds)
    }

    var currentLapTime: TimeInterval {
        elapsedTime - lapStartTime
    }

    var showCurrentLap: Bool {
        isRunning || elapsedTime > 0
    }

    var currentLapNumber: Int {
        laps.count + 1
    }

    var startStopButtonText: String {
        isRunning ? "Stop" : "Start"
    }

    var startStopButtonColor: Color {
        isRunning ? .red : .green
    }

    var lapResetButtonText: String {
        isRunning ? "Lap" : "Reset"
    }

    func startStopButtonPress() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }

    func lapResetButtonPress() {
        if isRunning {
            // Save the current lap duration and start a new lap
            let lapDuration = elapsedTime - lapStartTime
            laps.insert(lapDuration, at: 0)
            lapStartTime = elapsedTime
        } else {
            // Reset everything
            elapsedTime = 0
            lapStartTime = 0
            laps.removeAll()
        }
    }

    private func start() {
        isRunning = true
        startTime = Date()
        let previousElapsed = elapsedTime

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = previousElapsed + Date().timeIntervalSince(startTime)
        }
    }

    private func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
}
