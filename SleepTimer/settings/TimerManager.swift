//
//  TimerManager.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import Foundation

class TimerManager {
    static let shared = TimerManager()
    private var muteTimer: Timer?
    private var sleepTimer: Timer?

    func applyTimers() {
        let muteDelay = UserDefaults.standard.integer(forKey: "muteTimer") * 60
        let sleepDelay = UserDefaults.standard.integer(forKey: "sleepTimer") * 60

        // Cancel any existing timers
        muteTimer?.invalidate()
        sleepTimer?.invalidate()

        // Schedule Mute Timer
        if muteDelay > 0 {
            muteTimer = Timer.scheduledTimer(timeInterval: TimeInterval(muteDelay),
                                             target: self,
                                             selector: #selector(muteAudio),
                                             userInfo: nil,
                                             repeats: false)
        }

        // Schedule Sleep Timer
        if sleepDelay > 0 {
            sleepTimer = Timer.scheduledTimer(timeInterval: TimeInterval(sleepDelay),
                                              target: self,
                                              selector: #selector(putToSleep),
                                              userInfo: nil,
                                              repeats: false)
        }
    }

    @objc private func muteAudio() {
        let command = "osascript -e \"set volume output muted true\""
        runShellCommand(command)
    }

    @objc private func putToSleep() {
        let command = "pmset sleepnow"
        runShellCommand(command)
    }

    private func runShellCommand(_ command: String) {
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        process.launch()
    }
}
