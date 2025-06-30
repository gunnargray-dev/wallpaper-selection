import SwiftUI

// MARK: - Main Wallpaper Interaction View
struct WallpaperInteractionView: View {
    @State private var scaleFactor: CGFloat = 1.0
    @State private var isScrollEnabled = false
    @State private var currentWallpaperIndex: Int? = 0
    @State private var toolbarOpacity: Double = 1.0
    
    // Computed property for corner radius based on scale factor
    private var cornerRadius: CGFloat {
        return scaleFactor < 1.0 ? 36 : 0
    }
    
    // Sample wallpapers with images and fallback colors
    private let wallpapers: [WallpaperData] = [
        WallpaperData(imageName: "wallpaper_1", fallbackColor: Color(.systemGray5)),
        WallpaperData(imageName: "wallpaper_2", fallbackColor: .blue),
        WallpaperData(imageName: "wallpaper_3", fallbackColor: .green),
        WallpaperData(imageName: "wallpaper_4", fallbackColor: .orange)
    ]
    
    // Fixed screen dimensions - calculated once at initialization for best performance
    private let screenSize = UIScreen.main.bounds.size
    private let safeAreaInsets: EdgeInsets = {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return EdgeInsets(
                top: window.safeAreaInsets.top,
                leading: window.safeAreaInsets.left,
                bottom: window.safeAreaInsets.bottom,
                trailing: window.safeAreaInsets.right
            )
        }
        return EdgeInsets()
    }()
    
    var body: some View {
        ZStack {
            // Black background (visible when scaled)
            Color.black
                .ignoresSafeArea(.all)
            
            // ScrollView with individual wallpapers
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 32) { // Keep the 32px spacing
                        ForEach(wallpapers.indices, id: \.self) { index in
                            MainContentView(
                                wallpaper: wallpapers[index],
                                isFirstWallpaper: index == 0,
                                screenSize: screenSize,
                                safeAreaInsets: safeAreaInsets,
                                showBackground: true // Show background
                            )
                            .frame(width: screenSize.width, height: screenSize.height)
                            .id(index)
                            .onTapGesture {
                                if isScrollEnabled {
                                    selectWallpaper(at: index)
                                }
                            }
                        }
                    }
                    .scrollTargetLayout() // Add this modifier
                }
                .scrollDisabled(!isScrollEnabled) // Control scroll availability
                .scrollTargetBehavior(.viewAligned(limitBehavior: .alwaysByOne)) // Change behavior
                // removed drawingGroup to avoid rendering issues
                // .drawingGroup() // Rasterize during transform to avoid jitter
                // iOS 17+ specific fix for content clipping
                .scrollClipDisabled(true)
                .onLongPressGesture(minimumDuration: 0.5) {
                    initiateWallpaperSelection()
                }
            }
            .scaleEffect(scaleFactor, anchor: .center) // Scale from center for better visual
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // Add rounded corners when scaled down
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -100 && scaleFactor == 1.0 {
                        initiateWallpaperSelection()
                    } else if value.translation.height > 100 && scaleFactor < 1.0 {
                        dismissWallpaperSelector()
                    }
                }
        )
        .onChange(of: currentWallpaperIndex) { _, newIndex in
            // Handle wallpaper change during scrolling
            if isScrollEnabled, newIndex != nil {
                // Optional: Add haptic feedback or other effects
            }
        }
        .ignoresSafeArea(.all) // Critical: Ignore safe area on all edges to go truly edge-to-edge
    }
    
    private func initiateWallpaperSelection() {
        // Scale down animation with rounded corners
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            scaleFactor = 0.75
        }
        
        // Enable scroll after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isScrollEnabled = true
        }
    }
    
    private func dismissWallpaperSelector() {
        // First disable scrolling
        isScrollEnabled = false
        
        // Scale up animation with corner radius reset
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            scaleFactor = 1.0
        }
    }
    
    private func selectWallpaper(at index: Int) {
        // Update the current wallpaper index with animation
        withAnimation(.easeInOut(duration: 0.3)) {
            currentWallpaperIndex = index
        }
        
        // Dismiss the wallpaper selector
        dismissWallpaperSelector()
    }
}

// MARK: - Main Content View
struct MainContentView: View {
    let wallpaper: WallpaperData
    let isFirstWallpaper: Bool
    let screenSize: CGSize
    let safeAreaInsets: EdgeInsets
    let showBackground: Bool
    
    init(wallpaper: WallpaperData = WallpaperData(imageName: "wallpaper_1", fallbackColor: Color(.systemGray5)), isFirstWallpaper: Bool = true, screenSize: CGSize = CGSize(width: 400, height: 800), safeAreaInsets: EdgeInsets = EdgeInsets(), showBackground: Bool = true) {
        self.wallpaper = wallpaper
        self.isFirstWallpaper = isFirstWallpaper
        self.screenSize = screenSize
        self.safeAreaInsets = safeAreaInsets
        self.showBackground = showBackground
    }
    
    var body: some View {
        // Content without background
        VStack(spacing: 0) {
            Spacer()
            
            // Bottom input area with ultrathin material
            VStack(spacing: 12) {
                VStack(spacing: 16) {
                    // Input text area
                    HStack {
                        Text("Ask anything...")
                            .foregroundColor(.white.opacity(0.75))
                            .font(.system(size: 16))
                            .blendMode(.overlay)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Controls row
                    HStack {
                        // Left side controls
                        HStack(spacing: 8) {
                            // Plus button
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                    .blendMode(.overlay)
                                    .frame(width: 32, height: 32)
                                    .background(.ultraThinMaterial.opacity(0.5), in: Circle())
                            }
                            
                            // Search mode button
                            Button(action: {}) {
                                HStack() {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))
                                        .blendMode(.overlay)
                                }
                                .frame(height: 32)
                                .padding(.horizontal, 12)
                                .background(.ultraThinMaterial.opacity(0.5), in: Capsule())
                            }
                        }
                        
                        Spacer()
                        
                        // Right side controls
                        HStack(spacing: 8) {
                            // Microphone button
                            Button(action: {}) {
                                Image(systemName: "mic")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                    .blendMode(.overlay)
                                    .frame(width: 32, height: 32)
                                    .background(.ultraThinMaterial.opacity(0.5), in: Circle())
                            }
                            
                            // Voice-to-voice button (active)
                            Button(action: {}) {
                                Image(systemName: "waveform")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                    .blendMode(.overlay)
                                    .frame(width: 32, height: 32)
                                    .background(.ultraThinMaterial.opacity(0.5), in: Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.quaternary, lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
                .frame(height: 100)
                .background(.ultraThinMaterial.opacity(0.5), in: RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
            }
            .padding(.horizontal, 12)
            .padding(.bottom, max(safeAreaInsets.bottom, 34))
        }
        .frame(width: screenSize.width, height: screenSize.height)
        .clipped() // Ensure content doesn't overflow during scaling
        // Conditionally show background
        .background(
            Group {
                if showBackground {
                    WallpaperBackgroundView(
                        wallpaper: wallpaper,
                        isFirstWallpaper: isFirstWallpaper,
                        screenSize: screenSize
                    )
                }
            }
        )
    }
}

// MARK: - Wallpaper Data Model
struct WallpaperData: Identifiable {
    let id = UUID()
    let imageName: String
    let fallbackColor: Color
}

// MARK: - Wallpaper Background View
struct WallpaperBackgroundView: View {
    let wallpaper: WallpaperData
    let isFirstWallpaper: Bool
    let screenSize: CGSize  // Fixed screen size parameter
    
    var body: some View {
        if !wallpaper.imageName.isEmpty && UIImage(named: wallpaper.imageName) != nil {
            Image(wallpaper.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)  // Changed from .fit to .fill
                .frame(width: screenSize.width, height: screenSize.height)  // Explicit frame sizing
                .clipped()  // Clip overflow to prevent shifting
        } else {
            // Fallback colors for first wallpaper or missing images
            if isFirstWallpaper {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .frame(width: screenSize.width, height: screenSize.height)
            } else {
                wallpaper.fallbackColor
                    .frame(width: screenSize.width, height: screenSize.height)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    WallpaperInteractionView()
} 
