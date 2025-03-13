//
//  SettingsView.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("muteTimer") private var muteTimer = 0
    @AppStorage("sleepTimer") private var sleepTimer = 0
    
    var body: some View {
        VStack {
            Text("Settings").font(.title).padding()

            VStack(alignment: .leading) {
                Text("Mute Sound After (Minutes):")
                Stepper("\(muteTimer) min", value: $muteTimer, in: 0...120)
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Put Mac to Sleep After (Minutes):")
                Stepper("\(sleepTimer) min", value: $sleepTimer, in: 0...120)
            }
            .padding()

            Button("Save & Apply") {
                TimerManager.shared.applyTimers()
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}
