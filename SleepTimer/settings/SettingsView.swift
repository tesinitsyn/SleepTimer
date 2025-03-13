//
//  SettingsView.swift
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 13.03.2025.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage("muteEnabled") private var muteEnabled = false
    @AppStorage("muteTimer") private var muteTimer = 10

    @AppStorage("sleepEnabled") private var sleepEnabled = false
    @AppStorage("sleepTimer") private var sleepTimer = 60

    @Environment(\.colorScheme) var colorScheme
    @State private var buttonScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .padding(.top, 10)
                .opacity(0.9)

            settingsToggle(icon: "speaker.slash.fill", label: "Mute After", isOn: $muteEnabled, value: $muteTimer, colorScheme: colorScheme)
            settingsToggle(icon: "moon.fill", label: "Sleep After", isOn: $sleepEnabled, value: $sleepTimer, colorScheme: colorScheme)

            Button(action: {
                UserDefaults.standard.set(sleepEnabled, forKey: "sleepEnabled")
                UserDefaults.standard.set(sleepTimer, forKey: "sleepTimer")
                UserDefaults.standard.set(muteEnabled, forKey: "muteEnabled")
                UserDefaults.standard.set(muteTimer, forKey: "muteTimer")

                TimerManager.shared.applyTimers(startTimer: sleepEnabled || muteEnabled)

                DispatchQueue.main.async {
                    TimerManager.shared.appDelegate?.updateMenuBarTimer()
                }

                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    buttonScale = 1.15
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation { buttonScale = 1.0 }
                }

            }) {
                Text("Save & Apply")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.4), radius: 6, x: 0, y: 3)
                    .scaleEffect(buttonScale)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 15)
            .padding(.top, 10)
            .animation(.easeOut, value: buttonScale)

        }
        .padding(20)
        .frame(width: 320, height: 420)
        .background(
            Group {
                if colorScheme == .dark {
                    VisualEffectBlur(material: .sidebar, blendingMode: .withinWindow)
                } else {
                    Color(NSColor.windowBackgroundColor)
                }
            }
        )
        .shadow(color: colorScheme == .dark ? .black.opacity(0.2) : .gray.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

private func settingsToggle(icon: String, label: String, isOn: Binding<Bool>, value: Binding<Int>, colorScheme: ColorScheme) -> some View {
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
                .toggleStyle(SwitchToggleStyle())
        }

        if isOn.wrappedValue {
            VStack {
                Text("\(value.wrappedValue) min")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)

                AppKitSlider(value: value, minValue: 5, maxValue: 120, step: 5)
                    .frame(height: 20)
                    .padding(.horizontal, 8)
            }
            .padding(.top, 5)
        }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(
        Group {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08))
            } else {
                RoundedRectangle(cornerRadius: 12).fill(Color(NSColor.controlBackgroundColor))
            }
        }
    )
}


struct AppKitSlider: NSViewRepresentable {
    @Binding var value: Int
    let minValue: Int
    let maxValue: Int
    let step: Int

    class Coordinator: NSObject {
        var parent: AppKitSlider

        init(_ parent: AppKitSlider) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: NSSlider) {
            let newValue = round(sender.doubleValue / Double(parent.step)) * Double(parent.step)
            parent.value = Int(newValue)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSSlider {
        let slider = NSSlider(value: Double(value),
                              minValue: Double(minValue),
                              maxValue: Double(maxValue),
                              target: context.coordinator,
                              action: #selector(Coordinator.valueChanged(_:)))

        slider.isContinuous = true
        slider.allowsTickMarkValuesOnly = false
        slider.numberOfTickMarks = (maxValue - minValue) / step + 1
        slider.focusRingType = .none
        slider.controlSize = .regular
        slider.trackFillColor = NSColor.controlAccentColor 

        DispatchQueue.main.async {
            slider.window?.makeFirstResponder(slider)
        }

        return slider
    }

    func updateNSView(_ nsView: NSSlider, context: Context) {
        nsView.doubleValue = Double(value)
    }
}
#Preview {
    SettingsView()
}
