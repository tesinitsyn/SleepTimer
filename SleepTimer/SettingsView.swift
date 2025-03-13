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
        ZStack {
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)

                VStack {
                    HStack {
                        Image(systemName: "speaker.slash")
                            .foregroundColor(.blue)
                        Text("Mute After")
                        Spacer()
                        Stepper("\(muteTimer) min", value: $muteTimer, in: 0...120)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                }

                VStack {
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                        Text("Sleep After")
                        Spacer()
                        Stepper("\(sleepTimer) min", value: $sleepTimer, in: 0...120)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                }

                Button(action: {
                    TimerManager.shared.applyTimers()
                }) {
                    Text("Save & Apply")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                        .foregroundColor(.white)
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(width: 350, height: 220)
        }
        .background(VisualEffectBlur(material: .sidebar, blendingMode: .behindWindow))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    SettingsView()
}
