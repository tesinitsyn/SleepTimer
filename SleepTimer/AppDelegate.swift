//
//  AppDelegate.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        TimerManager.shared.applyTimers()
    }

    func setupMenuBar() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Mute", action: #selector(muteAudio), keyEquivalent: "M"))
        menu.addItem(NSMenuItem(title: "Unmute", action: #selector(unmuteAudio), keyEquivalent: "U"))
        menu.addItem(NSMenuItem(title: "Sleep", action: #selector(putToSleep), keyEquivalent: "S"))

        // Settings with Icon
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ",")
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(systemSymbolName: "speaker.wave.2", accessibilityDescription: "Sound Control")
        statusItem?.menu = menu
    }

    @objc func openSettings() {
        SettingsWindowController.shared.showWindow(nil)
    }


    @objc func muteAudio() {
        runShellCommand("osascript -e \"set volume output muted true\"")
    }

    @objc func unmuteAudio() {
        runShellCommand("osascript -e \"set volume output muted false\"")
    }

    @objc func putToSleep() {
        runShellCommand("pmset sleepnow")
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    func runShellCommand(_ command: String) {
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        process.launch()
    }
}
