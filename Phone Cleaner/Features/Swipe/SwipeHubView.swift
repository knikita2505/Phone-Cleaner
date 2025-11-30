import SwiftUI

/// Swipe Hub - экран выбора месяца для swipe-режима
struct SwipeHubView: View {
    @StateObject private var router = AppRouter.shared
    
    // Demo data
    private let months = [
        ("November 2024", 0, 618),
        ("October 2024", 156, 516),
        ("September 2024", 423, 489),
        ("August 2024", 302, 302)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spacingBlock) {
                // Header
                headerSection
                
                // Progress Summary
                progressSummarySection
                
                // Month List
                monthsListSection
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.top, AppSpacing.paddingInner)
            .padding(.bottom, 100)
        }
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("Swipe Photos")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            AnalyticsService.shared.logSwipeHubOpen()
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Swipe Photos")
                .titleLStyle()
            
            Text("Review your photos one by one. Swipe left to delete, right to keep.")
                .bodyMStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Progress Summary
    
    private var progressSummarySection: some View {
        PrimaryCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Overall Progress")
                        .subtitleMStyle()
                    Spacer()
                    Text("45%")
                        .font(AppTypography.titleM)
                        .foregroundColor(AppColors.accentBlue)
                }
                
                ProgressBar(
                    progress: 0.45,
                    gradientColors: [AppColors.accentBlue, AppColors.accentPurple]
                )
                
                Text("4 months in queue")
                    .captionStyle()
            }
        }
    }
    
    // MARK: - Months List
    
    private var monthsListSection: some View {
        VStack(spacing: AppSpacing.spacingSmall) {
            ForEach(months, id: \.0) { month in
                MonthCard(
                    title: month.0,
                    reviewed: month.1,
                    total: month.2
                ) {
                    router.navigate(to: .session(month: month.0))
                }
            }
        }
    }
}

/// Карточка месяца
struct MonthCard: View {
    let title: String
    let reviewed: Int
    let total: Int
    let action: () -> Void
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(reviewed) / Double(total)
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(AppTypography.subtitleM)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(reviewed)/\(total) reviewed")
                        .font(AppTypography.bodyM)
                        .foregroundColor(AppColors.textTertiary)
                    
                    ProgressBar(
                        progress: progress,
                        gradientColors: progress == 1.0 
                            ? [AppColors.success, Color(hex: "2FB89A")]
                            : [AppColors.accentBlue, AppColors.accentPurple],
                        height: 4
                    )
                    .frame(width: 120)
                }
                
                Spacer()
                
                Image(systemName: progress == 1.0 ? "checkmark.circle.fill" : "chevron.right")
                    .foregroundColor(progress == 1.0 ? AppColors.success : AppColors.textTertiary.opacity(0.5))
                    .font(.system(size: progress == 1.0 ? 24 : 14, weight: .semibold))
            }
            .padding(AppSpacing.paddingInner)
            .background(AppColors.cardBackground)
            .cornerRadius(AppSpacing.radiusCard)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - Preview

struct SwipeHubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SwipeHubView()
        }
    }
}

