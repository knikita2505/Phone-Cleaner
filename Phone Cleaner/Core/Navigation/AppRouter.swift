import SwiftUI

/// Основные вкладки приложения
enum AppTab: String, CaseIterable, Identifiable {
    case clean = "Clean"
    case swipe = "Swipe"
    case contacts = "Contacts"
    case secret = "Hide"
    case more = "More"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .clean: return "sparkles"
        case .swipe: return "hand.draw"
        case .contacts: return "person.crop.circle"
        case .secret: return "lock.fill"
        case .more: return "ellipsis.circle"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .clean: return "sparkles"
        case .swipe: return "hand.draw.fill"
        case .contacts: return "person.crop.circle.fill"
        case .secret: return "lock.fill"
        case .more: return "ellipsis.circle.fill"
        }
    }
}

/// Навигация внутри Clean модуля
enum CleanRoute: Hashable {
    case duplicatePhotos
    case similarPhotos
    case screenshots
    case livePhotos
    case videos
    case shortVideos
    case screenRecordings
}

/// Навигация внутри Swipe модуля
enum SwipeRoute: Hashable {
    case session(month: String)
}

/// Навигация внутри Contacts модуля
enum ContactsRoute: Hashable {
    case duplicates
    case similarNames
    case noName
    case noNumber
    case empty
    case merge(groupID: String)
}

/// Навигация внутри Secret модуля
enum SecretRoute: Hashable {
    case album
    case contacts
    case setupPasscode
}

/// Навигация внутри More модуля
enum MoreRoute: Hashable {
    case deviceHealth
    case batteryInsights
    case systemTips
    case cleaningHistory
    case settings
    case email
}

/// Роутер приложения
@MainActor
final class AppRouter: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AppRouter()
    
    // MARK: - Published Properties
    
    @Published var selectedTab: AppTab = .clean
    @Published var cleanPath: [CleanRoute] = []
    @Published var swipePath: [SwipeRoute] = []
    @Published var contactsPath: [ContactsRoute] = []
    @Published var secretPath: [SecretRoute] = []
    @Published var morePath: [MoreRoute] = []
    
    /// Показать paywall модально
    @Published var showPaywall: Bool = false
    @Published var paywallSource: String = "unknown"
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Navigation Methods
    
    func navigate(to route: CleanRoute) {
        selectedTab = .clean
        cleanPath.append(route)
    }
    
    func navigate(to route: SwipeRoute) {
        selectedTab = .swipe
        swipePath.append(route)
    }
    
    func navigate(to route: ContactsRoute) {
        selectedTab = .contacts
        contactsPath.append(route)
    }
    
    func navigate(to route: SecretRoute) {
        selectedTab = .secret
        secretPath.append(route)
    }
    
    func navigate(to route: MoreRoute) {
        selectedTab = .more
        morePath.append(route)
    }
    
    func showPaywall(source: String) {
        paywallSource = source
        showPaywall = true
        AnalyticsService.shared.logPaywallShown(source: source)
    }
    
    func dismissPaywall() {
        showPaywall = false
    }
    
    func popToRoot() {
        switch selectedTab {
        case .clean: cleanPath = []
        case .swipe: swipePath = []
        case .contacts: contactsPath = []
        case .secret: secretPath = []
        case .more: morePath = []
        }
    }
}

