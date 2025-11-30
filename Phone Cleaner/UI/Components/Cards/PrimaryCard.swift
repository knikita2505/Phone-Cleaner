import SwiftUI
import UIKit

/// Primary Card - основная карточка для Dashboard
/// Background: #111214, Radius: 20pt, Padding: 20pt
struct PrimaryCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppSpacing.paddingInnerLarge)
            .background(AppColors.backgroundSecondary)
            .cornerRadius(AppSpacing.radiusCard)
            .softShadow()
    }
}

/// Category Card - карточка категории на Dashboard (фото/видео)
struct CategoryCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let gradientColors: [Color]
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String,
        iconName: String,
        gradientColors: [Color] = [AppColors.accentBlue, AppColors.accentPurple],
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.gradientColors = gradientColors
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            VStack(alignment: .leading, spacing: AppSpacing.spacingSmall) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors.map { $0.opacity(0.2) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: AppSpacing.categoryIconSize, height: AppSpacing.categoryIconSize)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Spacer()
                
                // Title
                Text(title)
                    .font(AppTypography.subtitleM)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                
                // Subtitle (size)
                Text(subtitle)
                    .font(AppTypography.bodyM)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppSpacing.paddingInner)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 130)
            .background(AppColors.cardBackground)
            .cornerRadius(AppSpacing.radiusCard)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - Preview

struct PrimaryCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                PrimaryCard {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Space to clean")
                                .subtitleMStyle()
                            Text("2.4 GB")
                                .titleXLStyle()
                        }
                        Spacer()
                    }
                }
                
                HStack(spacing: 12) {
                    CategoryCard(
                        title: "Duplicates",
                        subtitle: "1.2 GB",
                        iconName: "square.on.square",
                        gradientColors: [AppColors.accentBlue, AppColors.accentPurple]
                    ) {
                        print("Tapped")
                    }
                    
                    CategoryCard(
                        title: "Screenshots",
                        subtitle: "456 MB",
                        iconName: "camera.viewfinder",
                        gradientColors: [AppColors.success, Color(hex: "2FB89A")]
                    ) {
                        print("Tapped")
                    }
                }
            }
            .padding()
        }
    }
}

