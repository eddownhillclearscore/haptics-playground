# Haptic Playground App
## Welcome to the Haptic Playground!
This app is a simple tool to experiment with custom haptic feedback patterns on your iOS device. It allows you to tweak various haptic parameters, such as intensity, sharpness, and duration, and instantly test them using Core Haptics.

## Features
Explore predefined haptic curves like Soft Pulse, Sharp Tap, and Long Vibration.
Customize haptic feedback with sliders for:
* Duration
* Intensity
* Sharpness
* Attack Time
* Release Time

## Setting Up the Project
Follow these steps to get the app running on your device:

### 1. Clone or Download the Repository:
Download the project as a ZIP file or clone the repository using:
bash
Copy code
git clone <repository-url>
Replace <repository-url> with the actual repository link.

### 2. Open the Project in Xcode:
Navigate to the project directory and open HapticPlayground.xcodeproj in Xcode.

### 3. Select a Target Device:
Connect your iOS device to your Mac or use a compatible simulator (though haptics are best experienced on physical devices).
Select your device from the list of available targets in Xcode's toolbar.

### 4. Configure Signing:
Go to the Signing & Capabilities tab in Xcode.
Choose your developer team or set up a new team if required.

### 5. Build and Run:
Press Cmd + R or click the Run button in Xcode to build and launch the app on your device.

## Testing the App
Open the app on your device.
Use the predefined haptic curves from the list or customize them with sliders.
Tap the play button to feel the haptic feedback.
Experiment with sliders to fine-tune your haptic patterns.

## Troubleshooting
### Haptic Feedback Not Working:
Ensure Core Haptics is supported on your device (physical device required).
Check if the Haptic Engine is running by reviewing the Xcode debug console for errors.
### Build Issues in Xcode:
Update to the latest version of Xcode.
Ensure your iOS device is running a version compatible with the app's deployment target.

### Happy experimenting! 🎉
