import Foundation
import Photos
import SwiftUI

// MARK: - Subscription Models

/// Статус подписки пользователя
enum SubscriptionStatus: String, Codable {
    case free
    case trial
    case premium
    case expired
}

/// Тарифный план
struct SubscriptionPlan: Identifiable {
    let id: String
    let type: PlanType
    let price: Decimal
    let currency: String
    let period: String
    let isMostPopular: Bool
    
    enum PlanType: String {
        case weekly
        case yearly
        case lifetime
    }
}

/// Модель пользователя
struct UserProfile: Codable {
    var subscriptionStatus: SubscriptionStatus
    var trialEndDate: Date?
    var filesDeletedToday: Int
    var lastCleanupDate: Date?
    
    static let freeFileLimit = 50
    
    var canDeleteFiles: Bool {
        subscriptionStatus == .premium ||
        subscriptionStatus == .trial ||
        filesDeletedToday < Self.freeFileLimit
    }
    
    var remainingFreeFiles: Int {
        max(0, Self.freeFileLimit - filesDeletedToday)
    }
}

// MARK: - Storage Models

/// Информация о хранилище устройства
struct StorageInfo {
    let totalSpace: Int64
    let usedSpace: Int64
    let freeSpace: Int64
    
    var usedPercentage: Double {
        guard totalSpace > 0 else { return 0 }
        return Double(usedSpace) / Double(totalSpace)
    }
    
    var formattedTotal: String {
        ByteCountFormatter.string(fromByteCount: totalSpace, countStyle: .file)
    }
    
    var formattedUsed: String {
        ByteCountFormatter.string(fromByteCount: usedSpace, countStyle: .file)
    }
    
    var formattedFree: String {
        ByteCountFormatter.string(fromByteCount: freeSpace, countStyle: .file)
    }
}

/// Категория очистки
struct CleanupCategory: Identifiable {
    let id: String
    let type: CategoryType
    var itemCount: Int
    var totalSize: Int64
    var isScanning: Bool
    
    enum CategoryType: String, CaseIterable {
        case duplicatePhotos = "Duplicate Photos"
        case similarPhotos = "Similar Photos"
        case screenshots = "Screenshots"
        case livePhotos = "Live Photos"
        case videos = "Videos"
        case shortVideos = "Short Videos"
        case screenRecordings = "Screen Recordings"
        
        var iconName: String {
            switch self {
            case .duplicatePhotos: return "square.on.square"
            case .similarPhotos: return "photo.stack"
            case .screenshots: return "camera.viewfinder"
            case .livePhotos: return "livephoto"
            case .videos: return "video.fill"
            case .shortVideos: return "play.rectangle.fill"
            case .screenRecordings: return "record.circle"
            }
        }
        
        var gradientColors: [Color] {
            switch self {
            case .duplicatePhotos: return [AppColors.accentBlue, AppColors.accentPurple]
            case .similarPhotos: return [AppColors.accentPurple, AppColors.accentLavender]
            case .screenshots: return [AppColors.success, Color(hex: "2FB89A")]
            case .livePhotos: return [AppColors.warning, Color(hex: "FF9500")]
            case .videos: return [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")]
            case .shortVideos: return [Color(hex: "FF6B6B"), AppColors.warning]
            case .screenRecordings: return [AppColors.accentGlow, AppColors.accentBlue]
            }
        }
    }
    
    var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: totalSize, countStyle: .file)
    }
}

// MARK: - Photo Models

/// Группа дубликатов фотографий
struct DuplicateGroup: Identifiable {
    let id: UUID
    var photos: [PhotoItem]
    var keepIndex: Int // индекс фото для сохранения
    
    var totalSize: Int64 {
        photos.reduce(0) { $0 + $1.fileSize }
    }
    
    var deletableSize: Int64 {
        photos.enumerated()
            .filter { $0.offset != keepIndex }
            .reduce(0) { $0 + $1.element.fileSize }
    }
}

/// Элемент фото
struct PhotoItem: Identifiable, Hashable {
    let id: String
    let asset: PHAsset
    let fileSize: Int64
    let creationDate: Date?
    let pixelWidth: Int
    let pixelHeight: Int
    var isSelected: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Contact Models

/// Категория контактов
enum ContactCategory: String, CaseIterable, Identifiable {
    case duplicates = "Duplicate Contacts"
    case similarNames = "Similar Names"
    case noName = "No Name Contacts"
    case noNumber = "No Number Contacts"
    case empty = "Empty Contacts"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .duplicates: return "person.2.fill"
        case .similarNames: return "person.text.rectangle.fill"
        case .noName: return "person.fill.questionmark"
        case .noNumber: return "phone.slash.fill"
        case .empty: return "person.slash.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .duplicates: return AppColors.accentPurple
        case .similarNames: return AppColors.accentBlue
        case .noName: return AppColors.warning
        case .noNumber: return AppColors.warning
        case .empty: return AppColors.error
        }
    }
}

// MARK: - Cleanup History

/// Запись в истории очистки
struct CleanupRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let category: String
    let itemsDeleted: Int
    let sizeFreed: Int64
    
    var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: sizeFreed, countStyle: .file)
    }
}

