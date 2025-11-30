import SwiftUI

/// More - экран дополнительных функций и настроек
struct MoreView: View {
    @StateObject private var router = AppRouter.shared
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spacingBlock) {
                // Premium Banner (if not subscribed)
                if !appState.isPremium {
                    premiumBanner
                }
                
                // Features Section
                featuresSection
                
                // Device Section
                deviceSection
                
                // Account Section
                accountSection
                
                // App Info
                appInfoSection
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.top, AppSpacing.paddingInner)
            .padding(.bottom, 100)
        }
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("More")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Premium Banner
    
    private var premiumBanner: some View {
        Button {
            router.showPaywall(source: "more")
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock Premium")
                        .font(AppTypography.subtitleL)
                        .foregroundColor(.white)
                    
                    Text("Get full access to all features")
                        .font(AppTypography.bodyM)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            .padding(AppSpacing.paddingInnerLarge)
            .background(AppColors.ctaGradient)
            .cornerRadius(AppSpacing.radiusCard)
        }
    }
    
    // MARK: - Features
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Features")
                .subtitleMStyle()
            
            SectionCard {
                VStack(spacing: 0) {
                    ListCard(
                        title: "Email Cleaner",
                        subtitle: "Clean spam & newsletters",
                        iconName: "envelope.fill",
                        iconColor: AppColors.warning
                    ) {
                        router.navigate(to: .email)
                    }
                }
            }
        }
    }
    
    // MARK: - Device
    
    private var deviceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Device")
                .subtitleMStyle()
            
            SectionCard {
                VStack(spacing: 0) {
                    ListCard(
                        title: "Device Health",
                        subtitle: "Check your device status",
                        iconName: "heart.fill",
                        iconColor: AppColors.success
                    ) {
                        router.navigate(to: .deviceHealth)
                    }
                    
                    sectionDivider
                    
                    ListCard(
                        title: "Battery Insights",
                        subtitle: "Battery tips & status",
                        iconName: "battery.100",
                        iconColor: AppColors.success
                    ) {
                        router.navigate(to: .batteryInsights)
                    }
                    
                    sectionDivider
                    
                    ListCard(
                        title: "System Tips",
                        subtitle: "Optimize your iPhone",
                        iconName: "lightbulb.fill",
                        iconColor: AppColors.warning
                    ) {
                        router.navigate(to: .systemTips)
                    }
                    
                    sectionDivider
                    
                    ListCard(
                        title: "Cleaning History",
                        subtitle: "View past cleanups",
                        iconName: "clock.arrow.circlepath",
                        iconColor: AppColors.accentPurple
                    ) {
                        router.navigate(to: .cleaningHistory)
                    }
                }
            }
        }
    }
    
    // MARK: - Account
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .subtitleMStyle()
            
            SectionCard {
                VStack(spacing: 0) {
                    ListCard(
                        title: "Settings",
                        subtitle: nil,
                        iconName: "gearshape.fill",
                        iconColor: AppColors.textTertiary
                    ) {
                        router.navigate(to: .settings)
                    }
                    
                    sectionDivider
                    
                    ListCard(
                        title: "Restore Purchases",
                        subtitle: nil,
                        iconName: "arrow.clockwise",
                        iconColor: AppColors.accentBlue
                    ) {
                        Task {
                            await SubscriptionService.shared.restorePurchases()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - App Info
    
    private var appInfoSection: some View {
        VStack(spacing: 8) {
            Text("Phone Cleaner")
                .font(AppTypography.bodyM)
                .foregroundColor(AppColors.textTertiary)
            
            Text("Version 1.0.0")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textTertiary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.spacingBlock)
    }
    
    // MARK: - Helpers
    
    private var sectionDivider: some View {
        Divider()
            .background(Color.white.opacity(0.1))
            .padding(.leading, 60)
    }
}

// MARK: - Preview

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MoreView()
        }
    }
}

