# SleepTimer for macOS

## Overview
**SleepTimer** is a simple yet powerful macOS menu bar utility that allows you to:
- **Automatically mute system audio** after a specified time.
- **Put your Mac to sleep** on a timer.
- **Customize time intervals** for both mute and sleep actions.
- **Receive system notifications** before sleep/mute actions with a cancellation option.

Built with **SwiftUI & AppKit**, this app integrates seamlessly into macOS, ensuring a smooth and native user experience.

---

## Features
✅ **Mute Audio Timer** – Set a timer to automatically mute your Mac's audio.  
✅ **Sleep Timer** – Schedule your Mac to go to sleep after a specified time.  
✅ **Menu Bar Integration** – Easily control timers from the macOS menu bar.  
✅ **Persistent Settings** – Your preferences are saved and applied automatically.  
✅ **Notifications & Alerts** – Get system alerts before sleep/mute actions with an option to cancel.  
✅ **Custom Time Intervals** – Adjust sleep and mute timers in increments of 5 minutes.  
✅ **macOS Native UI** – Uses AppKit components like `NSSlider` for a native experience.  

---

## Installation
### Requirements:
- macOS 12.0 or later
- Apple Silicon or Intel Mac

### Build from Source
1. Clone this repository:
   ```sh
   git clone https://github.com/yourusername/SleepTimer.git
   cd SleepTimer
   ```
2. Open `SleepTimer.xcodeproj` in Xcode.
3. Build and run the project.

---

## Usage
### 1️⃣ Configuring Timers
- Open the settings window from the **menu bar**.
- Enable **Mute After** or **Sleep After** toggles.
- Use the **slider** to set a time interval (5 to 120 min).
- Click **Save & Apply** to start timers.

### 2️⃣ Canceling Timers
- Click the **Cancel All Timers** button in the menu bar.
- Use the **notification alert** (if enabled) to cancel before execution.

### 3️⃣ Manually Putting Mac to Sleep
- Select **Sleep Now** from the menu bar for immediate sleep.

---

## Screenshots
| Light Mode | Dark Mode |
|------------|------------|
| ![Light Mode UI](https://github.com/user-attachments/assets/03126278-700b-4233-94e5-9f76719d6649) | ![Dark Mode UI](https://github.com/user-attachments/assets/eaeea07a-4084-4457-8234-0991e96e89f8) |


---

## Technical Details
### Tech Stack:
- **Swift & SwiftUI** – Core UI components
- **AppKit** – `NSSlider`, `NSMenu`, and `NSViewRepresentable` for macOS-specific behavior
- **UserNotifications** – System alerts for upcoming sleep/mute actions

### Key Implementations:
- `NSSlider` for **smooth drag interaction** (instead of SwiftUI `Slider`).
- `NSViewRepresentable` to **embed AppKit components** within SwiftUI.
- `UserDefaults` for **persistent settings storage**.

---

## Contributions
Contributions are welcome! Feel free to submit a pull request or report issues.

---

## License
This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

## Author
Developed by **Timofey Sinitsyn** – Feel free to reach out for collaborations!

