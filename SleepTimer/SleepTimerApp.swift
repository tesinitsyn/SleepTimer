//
//  SleepTimerApp.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import SwiftUI

@main
struct SleepTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
        var body: some Scene {
            Settings {
                ContentView()
            }
        }
}
