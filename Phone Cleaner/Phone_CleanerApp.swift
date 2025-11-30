import SwiftUI

@main
struct Phone_CleanerApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
        }
    }
}

/// Root View - определяет какой экран показывать
struct RootView: View {
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        Group {
            if appState.showOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.showOnboarding)
    }
}
