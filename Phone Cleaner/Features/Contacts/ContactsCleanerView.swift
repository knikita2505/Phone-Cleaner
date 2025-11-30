import SwiftUI

/// Contacts Cleaner - главный экран модуля контактов
struct ContactsCleanerView: View {
    @StateObject private var router = AppRouter.shared
    @StateObject private var permissionService = PermissionService.shared
    
    // Demo data
    @State private var categories: [(ContactCategory, Int)] = [
        (.duplicates, 12),
        (.similarNames, 8),
        (.noName, 5),
        (.noNumber, 3),
        (.empty, 2)
    ]
    
    var body: some View {
        Group {
            if permissionService.hasContactsAccess {
                contactsContent
            } else {
                permissionRequiredView
            }
        }
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            AnalyticsService.shared.logContactsCleanerOpened()
        }
    }
    
    // MARK: - Contacts Content
    
    private var contactsContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spacingBlock) {
                // Summary
                summarySection
                
                // Categories
                categoriesSection
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.top, AppSpacing.paddingInner)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Summary
    
    private var summarySection: some View {
        PrimaryCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Contacts Cleaner")
                    .titleMStyle()
                
                Text("Keep your address book clean and organized.")
                    .bodyMStyle()
                
                HStack(spacing: 16) {
                    summaryItem(
                        value: "12",
                        label: "duplicates",
                        color: AppColors.accentPurple
                    )
                    
                    summaryItem(
                        value: "8",
                        label: "incomplete",
                        color: AppColors.warning
                    )
                    
                    summaryItem(
                        value: "5",
                        label: "similar",
                        color: AppColors.accentBlue
                    )
                }
            }
        }
    }
    
    private func summaryItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppTypography.titleM)
                .foregroundColor(color)
            
            Text(label)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textTertiary)
        }
    }
    
    // MARK: - Categories
    
    private var categoriesSection: some View {
        VStack(spacing: AppSpacing.spacingSmall) {
            ForEach(categories, id: \.0.id) { category, count in
                ListCard(
                    title: category.rawValue,
                    subtitle: "\(count) contacts",
                    iconName: category.iconName,
                    iconColor: category.iconColor
                ) {
                    navigateToCategory(category)
                }
            }
        }
    }
    
    private func navigateToCategory(_ category: ContactCategory) {
        switch category {
        case .duplicates:
            router.navigate(to: .duplicates)
        case .similarNames:
            router.navigate(to: .similarNames)
        case .noName:
            router.navigate(to: .noName)
        case .noNumber:
            router.navigate(to: .noNumber)
        case .empty:
            router.navigate(to: .empty)
        }
    }
    
    // MARK: - Permission Required
    
    private var permissionRequiredView: some View {
        VStack(spacing: AppSpacing.spacingBlock) {
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: AppSpacing.iconPermission))
                .foregroundColor(AppColors.accentPurple)
            
            Text("Contacts Access Required")
                .titleMStyle()
                .multilineTextAlignment(.center)
            
            Text("We need access to your contacts to find duplicates and clean your address book.")
                .bodyMStyle()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(title: "Allow Access") {
                    Task {
                        await permissionService.requestContactsPermission()
                    }
                }
                
                GhostButton(title: "Open Settings") {
                    permissionService.openAppSettings()
                }
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Preview

struct ContactsCleanerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactsCleanerView()
        }
    }
}

