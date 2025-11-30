import SwiftUI

/// Типографика приложения согласно ui_design.md
/// Базовый шрифт: SF Pro (Display / Text)
enum AppTypography {
    
    // MARK: - Titles
    
    /// Title XL: 32pt Bold
    static let titleXL = Font.system(size: 32, weight: .bold, design: .default)
    
    /// Title L: 28pt Bold
    static let titleL = Font.system(size: 28, weight: .bold, design: .default)
    
    /// Title M: 24pt Semibold
    static let titleM = Font.system(size: 24, weight: .semibold, design: .default)
    
    // MARK: - Subtitles
    
    /// Subtitle L: 18pt Medium
    static let subtitleL = Font.system(size: 18, weight: .medium, design: .default)
    
    /// Subtitle M: 16pt Medium
    static let subtitleM = Font.system(size: 16, weight: .medium, design: .default)
    
    // MARK: - Body
    
    /// Body L: 16pt Regular
    static let bodyL = Font.system(size: 16, weight: .regular, design: .default)
    
    /// Body M: 14pt Regular
    static let bodyM = Font.system(size: 14, weight: .regular, design: .default)
    
    /// Caption: 12pt Regular
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    // MARK: - Button
    
    /// Primary button text: 18pt Medium
    static let buttonPrimary = Font.system(size: 18, weight: .medium, design: .default)
    
    /// Secondary button text: 16pt Medium
    static let buttonSecondary = Font.system(size: 16, weight: .medium, design: .default)
}

// MARK: - Text Style Modifiers

extension View {
    func titleXLStyle() -> some View {
        self
            .font(AppTypography.titleXL)
            .foregroundColor(AppColors.textPrimary)
    }
    
    func titleLStyle() -> some View {
        self
            .font(AppTypography.titleL)
            .foregroundColor(AppColors.textPrimary)
    }
    
    func titleMStyle() -> some View {
        self
            .font(AppTypography.titleM)
            .foregroundColor(AppColors.textPrimary)
    }
    
    func subtitleLStyle() -> some View {
        self
            .font(AppTypography.subtitleL)
            .foregroundColor(AppColors.textSecondary)
    }
    
    func subtitleMStyle() -> some View {
        self
            .font(AppTypography.subtitleM)
            .foregroundColor(AppColors.textSecondary)
    }
    
    func bodyLStyle() -> some View {
        self
            .font(AppTypography.bodyL)
            .foregroundColor(AppColors.textSecondary)
    }
    
    func bodyMStyle() -> some View {
        self
            .font(AppTypography.bodyM)
            .foregroundColor(AppColors.textSecondary)
    }
    
    func captionStyle() -> some View {
        self
            .font(AppTypography.caption)
            .foregroundColor(AppColors.textTertiary)
            .opacity(0.6)
    }
}

