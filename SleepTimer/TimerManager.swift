//
//  TimerManager.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import Foundation
import UserNotifications
import Cocoa


class TimerManager {
    static let shared = TimerManager()
    private var sleepTimer: Timer?
    private var cancelSleep = false

    private let isDebugMode = true // 🔥 Включаем тестовый режим

    func putToSleep() {
        let sleepDelay = UserDefaults.standard.integer(forKey: "sleepTimer") * 60

        let adjustedSleepDelay = isDebugMode ? max(sleepDelay / 60, 1) : sleepDelay // 🔥 Минимальное время 1 сек
        let warningTime = isDebugMode ? 5 : 300 // 🔥 5 секунд вместо 5 минут в тесте

        print("⏳ Таймер установлен на \(adjustedSleepDelay) секунд")

        if adjustedSleepDelay > 0 {
            showNotification(title: "Mac will sleep in \(adjustedSleepDelay) sec",
                             body: "A warning will appear in \(warningTime) sec.")

            if adjustedSleepDelay > warningTime {
                print("⚠️ Устанавливаем предупреждение за 5 минут")
                sleepTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(adjustedSleepDelay - warningTime), repeats: false) { _ in
                    if !self.cancelSleep {
                        self.showSleepWarning()
                    }
                }
            }

            print("💤 Устанавливаем финальный таймер сна через \(adjustedSleepDelay) секунд")
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(adjustedSleepDelay)) { [weak self] in
                guard let self = self else { return }
                if !self.cancelSleep {
                    print("💤 Mac уходит в сон!")
                    self.runShellCommand("pmset sleepnow")
                } else {
                    print("⏹ Сон отменён пользователем")
                }
            }
        } else {
            print("💤 Немедленный сон!")
            runShellCommand("pmset sleepnow")
        }
    }

    func applyTimers(startTimer: Bool = false) {
        cancelSleep = false

        let sleepEnabled = UserDefaults.standard.bool(forKey: "sleepEnabled")
        let muteEnabled = UserDefaults.standard.bool(forKey: "muteEnabled")

        if startTimer {
            if sleepEnabled {
                putToSleep()
            } else {
                print("⏹ Сон отключён в настройках, таймер не запускается")
            }

            if muteEnabled {
                muteAfterDelay()
            } else {
                print("🔇 Отключение звука выключено в настройках, таймер не запускается")
            }
        } else {
            print("⏳ Таймеры НЕ запущены автоматически при старте приложения.")
        }
        
        updateMenuBarTimer() // 🔥 Теперь обновляем меню-бар при каждом изменении таймеров
    }


    func muteAfterDelay() {
        let muteDelay = UserDefaults.standard.integer(forKey: "muteTimer") * 60
        let warningTime = 15 // 🔥 Уведомление за 5 секунд до отключения звука

        if muteDelay > 0 {
            print("🔇 Устанавливаем таймер на выключение звука через \(muteDelay) секунд")

            showNotification(title: "Sound will mute in \(muteDelay / 60) min",
                             body: "A warning will appear 5 sec before muting.")

            // Уведомление за 5 секунд до mute
            if muteDelay > warningTime {
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(muteDelay - warningTime)) { [weak self] in
                    if !(self?.cancelSleep ?? false) {
                        self?.showMuteWarning()
                    }
                }
            }

            // Таймер для mute
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(muteDelay)) { [weak self] in
                if !(self?.cancelSleep ?? false) {
                    self?.muteAudio()
                }
            }
        }
    }

    private func showMuteWarning() {
        let content = UNMutableNotificationContent()
        content.title = "Sound will mute in 5 sec"
        content.body = "Click 'Cancel' to prevent mute."
        content.sound = .default

        let cancelAction = UNNotificationAction(identifier: "CANCEL_MUTE", title: "Cancel", options: [.foreground])
        let category = UNNotificationCategory(identifier: "MUTE_WARNING", actions: [cancelAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = "MUTE_WARNING"

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }


    @objc private func muteAudio() {
        print("🔇 Выключаем звук!")
        runShellCommand("osascript -e \"set volume output muted true\"")
    }

    private func showSleepWarning() {
        let content = UNMutableNotificationContent()
        content.title = "Mac will sleep in 5 sec"
        content.body = "Click 'Cancel' to prevent sleep."
        content.sound = .default

        let cancelAction = UNNotificationAction(identifier: "CANCEL_SLEEP", title: "Cancel", options: [.foreground])
        let category = UNNotificationCategory(identifier: "SLEEP_WARNING", actions: [cancelAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = "SLEEP_WARNING"

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    private func showNotification(title: String, body: String) {
        print("🔔 Отправляем уведомление: \(title)")

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.interruptionLevel = .timeSensitive // 🔥 Теперь уведомление всегда будет видно

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Ошибка при отправке уведомления: \(error)")
            } else {
                print("✅ Уведомление отправлено и должно появиться на экране")
            }
        }
    }

    func cancelSleepTimer() {
        cancelSleep = true
        print("⏹ Таймер сна отменён!")
    }

    func cancelMuteTimer() {
        cancelSleep = true
        print("🔇 Таймер выключения звука отменён!")
    }

    func cancelAllTimers() {
        cancelSleep = true
        sleepTimer?.invalidate()
        print("❌ Все таймеры отменены!")

        showNotification(title: "All Timers Cancelled", body: "Sleep and mute timers have been stopped.")
        
        updateMenuBarTimer() // 🔥 Теперь обновляем меню-бар при отмене всех таймеров
    }


    func updateMenuBarTimer() {
        DispatchQueue.main.async {
            if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                appDelegate.updateMenuBarTimer()
            }
        }
    }


    private func runShellCommand(_ command: String) {
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        process.launch()
    }
}
