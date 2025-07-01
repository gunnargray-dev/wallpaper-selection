# Wallpaper Selector

<p align="center">
  <img src="wallpaperselector/Assets.xcassets/logo-pro.imageset/logo-pro.svg" alt="Wallpaper Selector Logo" width="120">
</p>

<p align="center">
  <strong>A beautiful, gesture-driven wallpaper selection experience for iOS</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS 17.0+">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift 5.9+">
  <img src="https://img.shields.io/badge/SwiftUI-✓-green.svg" alt="SwiftUI">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</p>

## Overview

Wallpaper Selector is a modern iOS application that provides an intuitive and visually appealing way to browse and select wallpapers. Built with SwiftUI, it features smooth animations, gesture-based interactions, and a clean, minimalist design inspired by contemporary iOS design patterns.

## ✨ Features

### Core Functionality
- **Gesture-Driven Navigation**: Long press or swipe up to enter selection mode
- **Smooth Animations**: Spring-based animations with 75% scale factor for selection mode
- **Rounded Corners**: Dynamic 36px corner radius when wallpapers are scaled down
- **Horizontal Scrolling**: Seamless wallpaper browsing with snap-to-view behavior

### User Interface
- **Dual Toolbar System**: 
  - Main toolbar with user avatar, logo, and globe icon
  - Selection toolbar with centered title and close button
- **Material Design**: Ultra-thin material backgrounds with custom opacity
- **Custom Assets**: Support for personalized avatars and branding
- **Edge-to-Edge Display**: Full-screen wallpaper viewing experience

### Interactions
- **Touch Gestures**: Long press, swipe up/down, and tap interactions
- **Visual Feedback**: Smooth transitions between viewing and selection modes
- **Intuitive Controls**: Clear visual cues for user actions

## 📱 Screenshots

> *Screenshots will be added here*

## 🛠 Requirements

- **iOS**: 17.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **Frameworks**: SwiftUI, Foundation

## 🚀 Installation

### Prerequisites
- Xcode 15 or later
- iOS 17.0+ deployment target
- macOS Ventura or later (for development)

### Setup

1. **Clone the repository**
   ```bash
   git clone git@github.com:gunnargray-dev/wallpaper-selection.git
   cd wallpaper-selection
   ```

2. **Open in Xcode**
   ```bash
   open wallpaperselector.xcodeproj
   ```

3. **Configure signing**
   - Select your development team in the project settings
   - Update the bundle identifier if needed

4. **Add your assets** (Optional)
   - Replace `avatar.png` with your profile image
   - Replace `logo-pro.svg` with your custom logo
   - Add additional wallpapers to the Assets catalog

5. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 📖 Usage

### Basic Navigation
1. **View wallpapers**: The app launches in full-screen wallpaper viewing mode
2. **Enter selection mode**: Long press anywhere or swipe up to scale down wallpapers
3. **Browse wallpapers**: Scroll horizontally through available options
4. **Select wallpaper**: Tap on any wallpaper to select and return to full-screen
5. **Exit selection**: Tap the close button or swipe down to return to viewing mode

### Gesture Controls
- **Long Press** (0.5s): Enter wallpaper selection mode
- **Swipe Up** (100px+): Enter wallpaper selection mode
- **Swipe Down** (100px+): Exit wallpaper selection mode
- **Tap**: Select wallpaper (in selection mode)
- **Horizontal Scroll**: Browse through wallpapers

## 🏗 Architecture

### Project Structure
```
wallpaperselector/
├── WallpaperSelectorApp.swift          # Main app entry point
├── ContentView.swift                   # Root content view
├── WallpaperInteractionView.swift      # Core interaction logic
└── Assets.xcassets/                    # Image and color assets
    ├── wallpaper_1.imageset/
    ├── wallpaper_2.imageset/
    ├── wallpaper_3.imageset/
    ├── wallpaper_4.imageset/
    ├── avatar.imageset/
    └── logo-pro.imageset/
```

### Key Components

#### Views
- **`WallpaperInteractionView`**: Main interaction controller with gesture handling
- **`MainContentView`**: Individual wallpaper content container
- **`MainToolbarView`**: Full-screen mode toolbar with branding
- **`ToolbarView`**: Selection mode toolbar with navigation
- **`BottomInputAreaView`**: Interactive bottom panel
- **`WallpaperBackgroundView`**: Wallpaper display component

#### Data Models
- **`WallpaperData`**: Wallpaper metadata and configuration

### Animation System
- **Spring Animations**: `response: 0.6, dampingFraction: 0.8`
- **Scale Factor**: 1.0 (full-screen) ↔ 0.75 (selection mode)
- **Corner Radius**: 0px (full-screen) ↔ 36px (selection mode)
- **Y Translation**: Toolbar slide animations with 50px offset

## 🎨 Customization

### Adding Wallpapers
1. Add images to `Assets.xcassets`
2. Create new `WallpaperData` entries in `wallpapers` array
3. Reference the asset name and provide a fallback color

### Styling
- **Corner Radius**: Modify `cornerRadius` computed property
- **Scale Factor**: Adjust `scaleFactor` values (0.75 default)
- **Animation Timing**: Update spring animation parameters
- **Material Opacity**: Customize background transparency

### Branding
- Replace `avatar.png` with your profile image
- Replace `logo-pro.svg` with your brand logo
- Update app name and metadata in project settings

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow Swift style guidelines
- Maintain SwiftUI best practices
- Ensure iOS 17+ compatibility
- Add comments for complex logic
- Test on multiple device sizes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Acknowledgments

- Built with [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Inspired by modern iOS design patterns
- Uses [SF Symbols](https://developer.apple.com/sf-symbols/) for icons

## 📞 Contact

**Project Maintainer**: [Your Name]
- GitHub: [@gunnargray-dev](https://github.com/gunnargray-dev)
- Project Link: [https://github.com/gunnargray-dev/wallpaper-selection](https://github.com/gunnargray-dev/wallpaper-selection)

---

<p align="center">
  Made with ❤️ and SwiftUI
</p> 