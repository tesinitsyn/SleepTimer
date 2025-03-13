//
//  AppDelegate.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import Cocoa
import SwiftUI
import UserNotifications


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        TimerManager.shared.applyTimers(startTimer: false)
        requestNotificationPermissions()
        registerNotificationActions()
        
        TimerManager.shared.appDelegate = self
    }

    
    func registerNotificationActions() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let cancelSleepAction = UNNotificationAction(identifier: "CANCEL_SLEEP", title: "Cancel Sleep", options: [.destructive])
        let sleepCategory = UNNotificationCategory(identifier: "SLEEP_WARNING", actions: [cancelSleepAction], intentIdentifiers: [], options: [])

        let cancelMuteAction = UNNotificationAction(identifier: "CANCEL_MUTE", title: "Cancel Mute", options: [.destructive])
        let muteCategory = UNNotificationCategory(identifier: "MUTE_WARNING", actions: [cancelMuteAction], intentIdentifiers: [], options: [])

        center.setNotificationCategories([sleepCategory, muteCategory])

        print("✅ Действия уведомлений зарегистрированы")
    }


    
    
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Ошибка при запросе разрешения на уведомления: \(error)")
            } else {
                print("✅ Разрешение на уведомления: \(granted ? "Да" : "Нет")")
            }
        }
    }


    func setupMenuBar() {
        let menu = NSMenu()
        
        let muteItem = NSMenuItem(title: "Mute in \(UserDefaults.standard.integer(forKey: "muteTimer")) min",
                                  action: #selector(startMuteTimer), keyEquivalent: "M")
        muteItem.tag = 101
        menu.addItem(muteItem)

        let sleepItem = NSMenuItem(title: "Sleep in \(UserDefaults.standard.integer(forKey: "sleepTimer")) min",
                                   action: #selector(putToSleep), keyEquivalent: "S")
        sleepItem.tag = 100
        menu.addItem(sleepItem)

        menu.addItem(NSMenuItem.separator())

        let cancelAllItem = NSMenuItem(title: "Cancel All Timers",
                                       action: #selector(cancelAllTimers), keyEquivalent: "C")
        cancelAllItem.tag = 102
        menu.addItem(cancelAllItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(systemSymbolName: "speaker.wave.2", accessibilityDescription: "Sound Control")
        statusItem?.menu = menu
    }

    @objc func cancelAllTimers() {
        TimerManager.shared.cancelAllTimers()
        updateMenuBarTimer()
    }



    @objc func putToSleep() {
        TimerManager.shared.applyTimers(startTimer: true)
    }


    func updateMenuBarTimer() {
        DispatchQueue.main.async {
            if let oldItem = self.statusItem {
                NSStatusBar.system.removeStatusItem(oldItem)
            }

            self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            self.statusItem?.button?.image = NSImage(systemSymbolName: "speaker.wave.2", accessibilityDescription: "Sound Control")

            let menu = NSMenu()
            
            let sleepTime = UserDefaults.standard.integer(forKey: "sleepTimer")
            let muteTime = UserDefaults.standard.integer(forKey: "muteTimer")

            let muteItem = NSMenuItem(title: "Mute in \(muteTime) min",
                                      action: #selector(self.startMuteTimer), keyEquivalent: "M")
            menu.addItem(muteItem)

            let sleepItem = NSMenuItem(title: "Sleep in \(sleepTime) min",
                                       action: #selector(self.putToSleep), keyEquivalent: "S")
            menu.addItem(sleepItem)

            menu.addItem(NSMenuItem.separator())

            let cancelAllItem = NSMenuItem(title: "Cancel All Timers",
                                           action: #selector(self.cancelAllTimers), keyEquivalent: "C")
            menu.addItem(cancelAllItem)

            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Settings", action: #selector(self.openSettings), keyEquivalent: ","))
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(self.quitApp), keyEquivalent: "Q"))

            self.statusItem?.menu = menu
        }
    }



    
    @objc func startMuteTimer() {
        TimerManager.shared.applyTimers(startTimer: true)
        updateMenuBarTimer()
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

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    private func runShellCommand(_ command: String) {
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        process.launch()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("🔔 Уведомление получено: \(response.actionIdentifier)")
        
        switch response.actionIdentifier {
        case "CANCEL_SLEEP":
            print("⏹ Сон отменён пользователем!")
            TimerManager.shared.cancelSleepTimer()
            
        case "CANCEL_MUTE":
            print("🔇 Отключение звука отменено пользователем!")
            TimerManager.shared.cancelMuteTimer()
            
        default:
            print("⚠️ Действие не обработано: \(response.actionIdentifier)")
        }
        
        completionHandler()
    }
}



