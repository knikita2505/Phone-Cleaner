import SwiftUI
import UIKit

/// List Card - карточка-строка для списков
/// Row-style, Height: 72-80pt, Icon left, Text stack, Chevron right
struct ListCard: View {
    let title: String
    let subtitle: String?
    let iconName: String
    let iconColor: Color
    let showChevron: Bool
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String? = nil,
        iconName: String,
        iconColor: Color = AppColors.accentBlue,
        showChevron: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.iconColor = iconColor
        self.showChevron = showChevron
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: AppSpacing.spacingIconText) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: AppSpacing.categoryIconSize, height: AppSpacing.categoryIconSize)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                // Text Stack
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppTypography.subtitleM)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppTypography.bodyM)
                            .foregroundColor(AppColors.textTertiary)
                    }
                }
                
                Spacer()
                
                // Chevron
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.textTertiary.opacity(0.5))
                }
            }
            .padding(.horizontal, AppSpacing.paddingInner)
            .frame(height: AppSpacing.listCardHeight)
            .background(AppColors.cardBackground)
            .cornerRadius(AppSpacing.radiusButton)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

/// Section Card - карточка секции для настроек
struct SectionCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppSpacing.radiusCard)
    }
}

// MARK: - Preview

struct ListCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ListCard(
                    title: "Duplicate Contacts",
                    subtitle: "12 duplicates found",
                    iconName: "person.2.fill",
                    iconColor: AppColors.accentPurple
                ) {
                    print("Tapped")
                }
                
                ListCard(
                    title: "Empty Contacts",
                    subtitle: "5 contacts",
                    iconName: "person.slash.fill",
                    iconColor: AppColors.warning
                ) {
                    print("Tapped")
                }
                
                SectionCard {
                    ListCard(
                        title: "Secret Folder",
                        subtitle: nil,
                        iconName: "lock.fill",
                        iconColor: AppColors.accentPurple
                    ) {}
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.leading, 60)
                    
                    ListCard(
                        title: "Device Health",
                        subtitle: nil,
                        iconName: "heart.fill",
                        iconColor: AppColors.success
                    ) {}
                }
            }
            .padding()
        }
    }
}

