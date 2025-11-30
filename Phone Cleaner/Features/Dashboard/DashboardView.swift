import SwiftUI

/// Dashboard - главный экран приложения
struct DashboardView: View {
    @StateObject private var appState = AppState.shared
    @StateObject private var router = AppRouter.shared
    
    // Demo values for skeleton
    @State private var potentialCleanup: Double = 2.4
    @State private var usedStorage: Double = 0.68
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spacingBlock) {
                // Header with Trial Button
                headerSection
                
                // Storage Summary
                storageSummarySection
                
                // Categories Grid
                categoriesSection
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.top, AppSpacing.paddingInner)
            .padding(.bottom, 100) // Extra padding for tab bar
        }
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
        .onAppear {
            AnalyticsService.shared.logDashboardOpen()
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            Spacer()
            
            if !appState.isPremium {
                trialButton
            }
        }
    }
    
    private var trialButton: some View {
        Button {
            router.showPaywall(source: "dashboard")
        } label: {
            Text("Start Free Trial")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.trialGradient)
                .cornerRadius(20)
        }
    }
    
    // MARK: - Storage Summary
    
    private var storageSummarySection: some View {
        PrimaryCard {
            VStack(spacing: AppSpacing.spacingBlock) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Space to clean")
                            .font(AppTypography.subtitleM)
                            .foregroundColor(AppColors.textTertiary)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(String(format: "%.1f", potentialCleanup))
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("GB")
                                .font(AppTypography.titleM)
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                    
                    Spacer()
                    
                    // Circular Progress
                    CircularProgressRing(
                        progress: usedStorage,
                        lineWidth: 10,
                        size: 80
                    )
                }
                
                // Storage Stats
                HStack(spacing: 20) {
                    storageStatItem(title: "Clutter", value: "1.8 GB")
                    storageStatItem(title: "Apps & data", value: "45.2 GB")
                    storageStatItem(title: "Total", value: "64 GB")
                }
            }
        }
    }
    
    private func storageStatItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textTertiary)
            
            Text(value)
                .font(AppTypography.bodyM)
                .foregroundColor(AppColors.textSecondary)
        }
    }
    
    // MARK: - Categories
    
    private var categoriesSection: some View {
        VStack(spacing: AppSpacing.spacingSmall) {
            // Row 1
            HStack(spacing: AppSpacing.spacingSmall) {
                CategoryCard(
                    title: "Duplicates",
                    subtitle: "1.2 GB",
                    iconName: "square.on.square",
                    gradientColors: [AppColors.accentBlue, AppColors.accentPurple]
                ) {
                    router.navigate(to: .duplicatePhotos)
                }
                
                CategoryCard(
                    title: "Similar",
                    subtitle: "456 MB",
                    iconName: "photo.stack",
                    gradientColors: [AppColors.accentPurple, AppColors.accentLavender]
                ) {
                    router.navigate(to: .similarPhotos)
                }
            }
            
            // Row 2
            HStack(spacing: AppSpacing.spacingSmall) {
                CategoryCard(
                    title: "Screenshots",
                    subtitle: "234 MB",
                    iconName: "camera.viewfinder",
                    gradientColors: [AppColors.success, Color(hex: "2FB89A")]
                ) {
                    router.navigate(to: .screenshots)
                }
                
                CategoryCard(
                    title: "Videos",
                    subtitle: "2.1 GB",
                    iconName: "video.fill",
                    gradientColors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")]
                ) {
                    router.navigate(to: .videos)
                }
            }
            
            // Row 3
            HStack(spacing: AppSpacing.spacingSmall) {
                CategoryCard(
                    title: "Short Videos",
                    subtitle: "156 MB",
                    iconName: "play.rectangle.fill",
                    gradientColors: [Color(hex: "FF6B6B"), AppColors.warning]
                ) {
                    router.navigate(to: .shortVideos)
                }
                
                CategoryCard(
                    title: "Recordings",
                    subtitle: "890 MB",
                    iconName: "record.circle",
                    gradientColors: [AppColors.accentGlow, AppColors.accentBlue]
                ) {
                    router.navigate(to: .screenRecordings)
                }
            }
        }
    }
}

// MARK: - Preview

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

