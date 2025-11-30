import SwiftUI

/// Цветовая палитра приложения согласно ui_design.md
enum AppColors {
    
    // MARK: - Background Colors
    
    /// Глубокий тёмный синий - основной фон
    static let backgroundPrimary = Color(hex: "0D0F16")
    
    /// Графитовый - для рабочих экранов
    static let backgroundSecondary = Color(hex: "111214")
    
    /// Фон для карточек
    static let cardBackground = Color(hex: "121317")
    
    // MARK: - Accent Colors
    
    /// Основной синий
    static let accentBlue = Color(hex: "3B5BFF")
    
    /// Фиолетовый
    static let accentPurple = Color(hex: "7A4DFB")
    
    /// Сиреневый светлый
    static let accentLavender = Color(hex: "A88CFF")
    
    /// Голубое свечение
    static let accentGlow = Color(hex: "7FB9FF")
    
    // MARK: - Text Colors
    
    /// Основной текст (bold headers)
    static let textPrimary = Color.white
    
    /// Вторичный текст (описания)
    static let textSecondary = Color(hex: "E6E8ED")
    
    /// Третичный текст (системные)
    static let textTertiary = Color(hex: "AEB4BE")
    
    // MARK: - Status Colors
    
    /// Успех
    static let success = Color(hex: "41D3B3")
    
    /// Предупреждение
    static let warning = Color(hex: "FFB84D")
    
    /// Ошибка
    static let error = Color(hex: "FF4D4D")
    
    // MARK: - Gradients
    
    /// CTA Gradient (primary button)
    static let ctaGradient = LinearGradient(
        colors: [Color(hex: "3B5BFF"), Color(hex: "7A4DFB")],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Aurora Gradient (для онбординга и paywalls)
    static let auroraGradient = LinearGradient(
        colors: [
            Color(hex: "2F3DAF"),
            Color(hex: "6B3BDB"),
            Color(hex: "8B5CFF")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Storage progress gradient
    static let storageGradient = LinearGradient(
        colors: [Color(hex: "FF8D4D"), Color(hex: "FFD36B")],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Trial button gradient (зелёный)
    static let trialGradient = LinearGradient(
        colors: [Color(hex: "41D3B3"), Color(hex: "2FB89A")],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

