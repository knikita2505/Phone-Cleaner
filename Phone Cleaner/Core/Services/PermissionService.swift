import Foundation
import Photos
import Contacts
import UserNotifications
import UIKit

/// Сервис управления разрешениями
@MainActor
final class PermissionService: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = PermissionService()
    
    // MARK: - Published Properties
    
    @Published var photoAuthorizationStatus: PHAuthorizationStatus = .notDetermined
    @Published var contactsAuthorizationStatus: CNAuthorizationStatus = .notDetermined
    @Published var notificationAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    
    // MARK: - Computed Properties
    
    var hasPhotoAccess: Bool {
        photoAuthorizationStatus == .authorized || photoAuthorizationStatus == .limited
    }
    
    var hasFullPhotoAccess: Bool {
        photoAuthorizationStatus == .authorized
    }
    
    var hasContactsAccess: Bool {
        contactsAuthorizationStatus == .authorized
    }
    
    var hasNotificationsAccess: Bool {
        notificationAuthorizationStatus == .authorized
    }
    
    // MARK: - Init
    
    private init() {
        checkCurrentStatus()
    }
    
    // MARK: - Status Check
    
    func checkCurrentStatus() {
        photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        contactsAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            notificationAuthorizationStatus = settings.authorizationStatus
        }
    }
    
    // MARK: - Request Photo Permission
    
    func requestPhotoPermission() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        photoAuthorizationStatus = status
        
        if status == .authorized || status == .limited {
            AnalyticsService.shared.logOnboardingPermissionGranted()
            return true
        } else {
            AnalyticsService.shared.logOnboardingPermissionDenied()
            return false
        }
    }
    
    // MARK: - Request Contacts Permission
    
    func requestContactsPermission() async -> Bool {
        let store = CNContactStore()
        
        do {
            let granted = try await store.requestAccess(for: .contacts)
            contactsAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            
            if granted {
                AnalyticsService.shared.logEvent("perm_contacts_granted")
            } else {
                AnalyticsService.shared.logEvent("perm_contacts_denied")
            }
            
            return granted
        } catch {
            AnalyticsService.shared.logEvent("perm_contacts_denied")
            return false
        }
    }
    
    // MARK: - Request Notification Permission
    
    func requestNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            let settings = await center.notificationSettings()
            notificationAuthorizationStatus = settings.authorizationStatus
            
            if granted {
                AnalyticsService.shared.logEvent("perm_push_granted")
            } else {
                AnalyticsService.shared.logEvent("perm_push_denied")
            }
            
            return granted
        } catch {
            AnalyticsService.shared.logEvent("perm_push_denied")
            return false
        }
    }
    
    // MARK: - Open Settings
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

