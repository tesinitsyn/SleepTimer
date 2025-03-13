//
//  SettingsView.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import SwiftUI

import SwiftUI

struct SettingsView: View {
    @AppStorage("muteEnabled") private var muteEnabled = false
    @AppStorage("muteTimer") private var muteTimer = 10  // 🔥 Шаги кратны 5

    @AppStorage("sleepEnabled") private var sleepEnabled = false
    @AppStorage("sleepTimer") private var sleepTimer = 60  // 🔥 Шаги кратны 5

    var body: some View {
        ZStack {
            VisualEffectBlur(material: .fullScreenUI, blendingMode: .behindWindow)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.top, 10)

                settingsToggle(icon: "speaker.slash.fill", label: "Mute After", isOn: $muteEnabled, value: $muteTimer)
                settingsToggle(icon: "moon.fill", label: "Sleep After", isOn: $sleepEnabled, value: $sleepTimer)

                Button(action: {
                    // ✅ Сохраняем настройки
                    UserDefaults.standard.set(sleepEnabled, forKey: "sleepEnabled")
                    UserDefaults.standard.set(sleepTimer, forKey: "sleepTimer")
                    UserDefaults.standard.set(muteEnabled, forKey: "muteEnabled")
                    UserDefaults.standard.set(muteTimer, forKey: "muteTimer")

                    // ✅ Запускаем таймеры
                    TimerManager.shared.applyTimers(startTimer: sleepEnabled || muteEnabled)

                    // ✅ Теперь обновляем меню-бар через appDelegate
                    DispatchQueue.main.async {
                        if let appDelegate = TimerManager.shared.appDelegate {
                            appDelegate.updateMenuBarTimer()
                        } else {
                            print("⚠️ Ошибка: AppDelegate не найден в TimerManager")
                        }
                    }

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
            .frame(width: 500, height: 500)
            .background(
                VisualEffectBlur(material: .sidebar, blendingMode: .withinWindow)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            )
            .shadow(radius: 10)
        }
    }
    
    private func settingsToggle(icon: String, label: String, isOn: Binding<Bool>, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isOn.wrappedValue ? .accentColor : .gray)
                    .font(.system(size: 18, weight: .medium))

                Text(label)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)

                Spacer()

                Toggle("", isOn: isOn)
                    .toggleStyle(SwitchToggleStyle()) // 🔥 macOS-style toggle
            }
            
            if isOn.wrappedValue {
                VStack {
                    Text("\(value.wrappedValue) min")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .animation(.easeInOut, value: value.wrappedValue)

                    Slider(value: Binding(get: {
                        Double(value.wrappedValue)
                    }, set: { newValue in
                        value.wrappedValue = Int(newValue)
                    }), in: 5...120, step: 5) // 🔥 Шаг 5 минут
                    .accentColor(.accentColor)
                    .padding(.horizontal, 8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
        .shadow(radius: 2)
        .animation(.easeInOut(duration: 0.3), value: isOn.wrappedValue)
    }
}





#Preview {
    SettingsView()
}
