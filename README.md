# Emoji animation game

This is a simple iOS game that demonstrates the use of animations, gestures, and CoreMotion to create an interactive experience with emojis. The project is built using Swift and UIKit, and it serves as a practice exercise for working with various gesture recognizers and motion detection.

## Features

- **Tap Gesture**: tapping on the screen generates a random emoji at the tap location
- **Long Press Gesture**: holding down on the screen continuously generates emojis at the touch location
- **Pan Gesture**: dragging your finger across the screen generates a trail of emojis
- **Shake Gesture**: shaking the device causes all emojis on the screen to explode and disappear
- **Gravity and Collision**: emojis are affected by gravity and collide with each other and the screen boundaries

## Technologies Used

- **UIKit**: creating and managing the user interface
- **CoreMotion**: to detect device motion and apply corresponding gravity to the emojis
- **UIImpactFeedbackGenerator**: to createe haptics to simulate physical impacts
- **Gesture Recognizers**: to handle various user interactions such as taps, pans, long presses

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/nastyabeggin/Animation-playground
   ```

2. Open the project in Xcode:

   ```bash
   cd Animation-playground
   open AnimationTestApp.xcodeproj
   ```

3. Build and run the project on a simulator or physical device.

## Usage

- Tap anywhere on the screen to create an emoji
- Rotate your phone to see how the gravity affects emojis
- Long press on the screen to generate multiple emojis at the same spot
- Drag your finger across the screen to create a trail of emojis
- Shake your device to make the emojis explode
