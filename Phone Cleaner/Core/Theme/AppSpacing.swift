import SwiftUI

/// Отступы и размеры согласно ui_design.md
enum AppSpacing {
    
    // MARK: - Outer Padding
    
    /// Внешние отступы: 20-24pt
    static let paddingOuter: CGFloat = 20
    static let paddingOuterLarge: CGFloat = 24
    
    // MARK: - Inner Padding
    
    /// Внутренние отступы в контейнерах: 16-20pt
    static let paddingInner: CGFloat = 16
    static let paddingInnerLarge: CGFloat = 20
    
    // MARK: - Spacing
    
    /// Между блоками: 16pt
    static let spacingBlock: CGFloat = 16
    
    /// Между иконкой и текстом: 12pt
    static let spacingIconText: CGFloat = 12
    
    /// Малый отступ
    static let spacingSmall: CGFloat = 8
    
    /// Минимальный отступ
    static let spacingXSmall: CGFloat = 4
    
    // MARK: - Corner Radius
    
    /// Карточки: 20pt
    static let radiusCard: CGFloat = 20
    
    /// Кнопки: 16-20pt
    static let radiusButton: CGFloat = 16
    static let radiusButtonLarge: CGFloat = 20
    
    /// Модалки: 32pt
    static let radiusModal: CGFloat = 32
    
    /// Прогресс-бары: full (4pt для height 8)
    static let radiusProgress: CGFloat = 4
    
    // MARK: - Button Heights
    
    /// Primary button height: 56pt
    static let buttonHeightPrimary: CGFloat = 56
    
    /// Secondary button height: 48pt
    static let buttonHeightSecondary: CGFloat = 48
    
    // MARK: - Icon Sizes
    
    /// Standard icon: 24pt
    static let iconStandard: CGFloat = 24
    
    /// Large icon: 32pt
    static let iconLarge: CGFloat = 32
    
    /// Permission icon: 80pt
    static let iconPermission: CGFloat = 80
    
    // MARK: - Card Heights
    
    /// List card height: 72-80pt
    static let listCardHeight: CGFloat = 76
    
    /// Category card icon size: 36-44pt
    static let categoryIconSize: CGFloat = 40
}

// MARK: - Shadow Style

extension View {
    /// Стандартная тень для карточек
    func cardShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.3),
            radius: 10,
            x: 0,
            y: 4
        )
    }
    
    /// Лёгкая тень
    func softShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.2),
            radius: 8,
            x: 0,
            y: 2
        )
    }
}

