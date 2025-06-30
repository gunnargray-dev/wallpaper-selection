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
                                showBackground: true, // Show background
                                cornerRadius: cornerRadius
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
        }
        .overlay(
            // Toolbar overlay - separate from wallpaper content
            ToolbarView(
                isVisible: scaleFactor < 1.0,
                opacity: toolbarOpacity,
                onDismiss: dismissWallpaperSelector
            )
        )
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
        // Scale down animation with rounded corners and show toolbar
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            scaleFactor = 0.75
            toolbarOpacity = 1.0
        }
        
        // Enable scroll after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isScrollEnabled = true
        }
    }
    
    private func dismissWallpaperSelector() {
        // First disable scrolling
        isScrollEnabled = false
        
        // Scale up animation with corner radius reset and hide toolbar
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            scaleFactor = 1.0
            toolbarOpacity = 0.0
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
    let cornerRadius: CGFloat
    
    init(wallpaper: WallpaperData = WallpaperData(imageName: "wallpaper_1", fallbackColor: Color(.systemGray5)), isFirstWallpaper: Bool = true, screenSize: CGSize = CGSize(width: 400, height: 800), safeAreaInsets: EdgeInsets = EdgeInsets(), showBackground: Bool = true, cornerRadius: CGFloat = 0) {
        self.wallpaper = wallpaper
        self.isFirstWallpaper = isFirstWallpaper
        self.screenSize = screenSize
        self.safeAreaInsets = safeAreaInsets
        self.showBackground = showBackground
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        // Content without background
        VStack(spacing: 0) {
            Spacer()
            
            BottomInputAreaView(safeAreaInsets: safeAreaInsets)
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
                        screenSize: screenSize,
                        cornerRadius: cornerRadius
                    )
                }
            }
        )
    }
}

// MARK: - Bottom Input Area View
struct BottomInputAreaView: View {
    let safeAreaInsets: EdgeInsets
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 16) {
                InputTextAreaView()
                ControlsRowView()
            }
            .frame(height: 100)
            .background {
                ZStack {
                    // Color.black.opacity(0.9) // Dark base layer
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(1.0) // Material overlay
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 12)
        .padding(.bottom, max(safeAreaInsets.bottom, 34))
    }
}

// MARK: - Input Text Area View
struct InputTextAreaView: View {
    var body: some View {
        HStack {
            Text("Ask anything...")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 16))
                
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Controls Row View
struct ControlsRowView: View {
    var body: some View {
        HStack {
            LeftSideControlsView()
            Spacer()
            RightSideControlsView()
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }
}

// MARK: - Left Side Controls View
struct LeftSideControlsView: View {
    var body: some View {
        HStack(spacing: 8) {
            // Plus button
            Button(action: {}) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    
                    .frame(width: 32, height: 32)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                            
                    }
            }
            
            // Search mode button
            Button(action: {}) {
                HStack() {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        
                }
                .frame(width: 32, height: 32)
                
                .background {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        
                }
            }
        }
    }
}

// MARK: - Right Side Controls View
struct RightSideControlsView: View {
    var body: some View {
        HStack(spacing: 8) {
            // Microphone button
            Button(action: {}) {
                Image(systemName: "mic")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 32, height: 32)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                            
                    }
            }
            
            // Voice-to-voice button (active)
            Button(action: {}) {
                Image(systemName: "waveform")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                   
                    .frame(width: 32, height: 32)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                    }
            }
        }
    }
}

// MARK: - Toolbar View
struct ToolbarView: View {
    let isVisible: Bool
    let opacity: Double
    let onDismiss: () -> Void
    
    var body: some View {
        if isVisible {
            VStack {
                HStack {
                    // Title
                    Text("Choose a wallpaper")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    // Close button
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 32, height: 32)
                            .background {
                                Circle()
                                    .fill(.ultraThinMaterial)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 60) // Account for safe area
                
                Spacer()
            }
            .opacity(opacity)
        }
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
    let cornerRadius: CGFloat
    
    var body: some View {
        Group {
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
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // Apply rounded corners to individual wallpaper
    }
}

// MARK: - Preview
#Preview {
    WallpaperInteractionView()
} 
