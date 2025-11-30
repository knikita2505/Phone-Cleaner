import Foundation
import SwiftUI
import Combine

/// Глобальное состояние приложения
@MainActor
final class AppState: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AppState()
    
    // MARK: - Published Properties
    
    /// Профиль пользователя
    @Published var userProfile: UserProfile
    
    /// Информация о хранилище
    @Published var storageInfo: StorageInfo?
    
    /// Категории для очистки
    @Published var cleanupCategories: [CleanupCategory] = []
    
    /// Показывать ли онбординг
    @Published var showOnboarding: Bool
    
    /// Показывать ли paywall
    @Published var showPaywall: Bool = false
    
    /// Статус разрешений
    @Published var hasPhotoPermission: Bool = false
    @Published var hasContactsPermission: Bool = false
    @Published var hasNotificationPermission: Bool = false
    
    /// Потенциальный объём для очистки
    @Published var potentialCleanupSize: Int64 = 0
    
    // MARK: - Computed Properties
    
    var isPremium: Bool {
        userProfile.subscriptionStatus == .premium ||
        userProfile.subscriptionStatus == .trial
    }
    
    var formattedCleanupSize: String {
        ByteCountFormatter.string(fromByteCount: potentialCleanupSize, countStyle: .file)
    }
    
    // MARK: - Init
    
    private init() {
        // Загружаем сохранённое состояние или используем значения по умолчанию
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.showOnboarding = !hasSeenOnboarding
        
        // Загружаем профиль пользователя
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = profile
        } else {
            self.userProfile = UserProfile(
                subscriptionStatus: .free,
                trialEndDate: nil,
                filesDeletedToday: 0,
                lastCleanupDate: nil
            )
        }
        
        // Сбрасываем счётчик файлов, если новый день
        resetDailyLimitIfNeeded()
        
        // Инициализируем категории
        initializeCategories()
    }
    
    // MARK: - Methods
    
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
    
    func saveUserProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }
    
    func incrementDeletedFiles(count: Int) {
        userProfile.filesDeletedToday += count
        userProfile.lastCleanupDate = Date()
        saveUserProfile()
    }
    
    func updateSubscriptionStatus(_ status: SubscriptionStatus) {
        userProfile.subscriptionStatus = status
        saveUserProfile()
    }
    
    private func resetDailyLimitIfNeeded() {
        guard let lastDate = userProfile.lastCleanupDate else { return }
        
        if !Calendar.current.isDateInToday(lastDate) {
            userProfile.filesDeletedToday = 0
            saveUserProfile()
        }
    }
    
    private func initializeCategories() {
        cleanupCategories = CleanupCategory.CategoryType.allCases.map { type in
            CleanupCategory(
                id: type.rawValue,
                type: type,
                itemCount: 0,
                totalSize: 0,
                isScanning: false
            )
        }
    }
}

