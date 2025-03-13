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
            VisualEffectBlur(material: .fullScreenUI, blendingMode: .behindWindow)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {  // Increased spacing
                Text("Settings")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                settingsCard(icon: "speaker.slash.fill", label: "Mute After", value: $muteTimer)
                settingsCard(icon: "moon.fill", label: "Sleep After", value: $sleepTimer)

                Button(action: {
                    TimerManager.shared.applyTimers()
                }) {
                    Text("Save & Apply")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            .padding(20)
            .frame(width: 300, height: 300)  // 🔥 Increased size
            .background(
                VisualEffectBlur(material: .sidebar, blendingMode: .withinWindow)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            )
            .shadow(radius: 10)
        }
    }
    
    private func settingsCard(icon: String, label: String, value: Binding<Int>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .font(.system(size: 18, weight: .medium)) // Increased icon size
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Stepper("", value: value, in: 0...120)
                .labelsHidden()
                .frame(width: 80)  // More space for Stepper
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
        .shadow(radius: 2)
    }
}



#Preview {
    SettingsView()
}
