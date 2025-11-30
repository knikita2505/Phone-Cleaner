import SwiftUI

/// Главный экран с TabBar
struct MainTabView: View {
    @StateObject private var router = AppRouter.shared
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            TabContent(selectedTab: router.selectedTab)
                .padding(.bottom, 80) // Space for custom tab bar
            
            // Custom Tab Bar
            MainTabBar(selectedTab: $router.selectedTab)
        }
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
        .sheet(isPresented: $router.showPaywall) {
            PaywallView(source: router.paywallSource)
        }
    }
}

/// Контент вкладок
struct TabContent: View {
    let selectedTab: AppTab
    
    var body: some View {
        switch selectedTab {
        case .clean:
            NavigationStack(path: .constant([CleanRoute]())) {
                DashboardView()
            }
        case .swipe:
            NavigationStack(path: .constant([SwipeRoute]())) {
                SwipeHubView()
            }
        case .contacts:
            NavigationStack(path: .constant([ContactsRoute]())) {
                ContactsCleanerView()
            }
        case .secret:
            NavigationStack(path: .constant([SecretRoute]())) {
                SecretSpaceView()
            }
        case .more:
            NavigationStack(path: .constant([MoreRoute]())) {
                MoreView()
            }
        }
    }
}

// MARK: - Preview

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

