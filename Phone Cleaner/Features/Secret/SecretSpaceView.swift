import SwiftUI

/// Secret Space - главный экран секретного хранилища
struct SecretSpaceView: View {
    @StateObject private var router = AppRouter.shared
    @StateObject private var appState = AppState.shared
    
    @State private var isUnlocked = false
    @State private var hiddenItemsCount = 0
    
    var body: some View {
        Group {
            if !appState.isPremium {
                premiumRequiredView
            } else if isUnlocked {
                secretContent
            } else {
                lockScreen
            }
        }
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("Secret Space")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            AnalyticsService.shared.logSecretSpaceOpen()
        }
    }
    
    // MARK: - Lock Screen
    
    private var lockScreen: some View {
        VStack(spacing: AppSpacing.spacingBlock) {
            Spacer()
            
            Image(systemName: "lock.fill")
                .font(.system(size: AppSpacing.iconPermission))
                .foregroundColor(AppColors.accentPurple)
            
            Text("Secret Space")
                .titleMStyle()
            
            Text("Your private photos, videos and contacts are protected.")
                .bodyMStyle()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            PrimaryButton(title: "Unlock with Face ID") {
                // TODO: Implement Face ID unlock
                isUnlocked = true
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Secret Content
    
    private var secretContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spacingBlock) {
                // Header
                headerSection
                
                // Status
                statusSection
                
                // Sections
                sectionsSection
                
                // Protection Settings
                protectionSection
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.top, AppSpacing.paddingInner)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Secret Space")
                .titleLStyle()
            
            Text("Hide your private photos, videos and contacts.")
                .bodyMStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Status
    
    private var statusSection: some View {
        PrimaryCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hidden Items")
                        .subtitleMStyle()
                    
                    Text("\(hiddenItemsCount) items hidden")
                        .bodyMStyle()
                }
                
                Spacer()
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.success)
            }
        }
    }
    
    // MARK: - Sections
    
    private var sectionsSection: some View {
        VStack(spacing: AppSpacing.spacingSmall) {
            ListCard(
                title: "Secret Album",
                subtitle: "0 photos & videos",
                iconName: "photo.on.rectangle.angled",
                iconColor: AppColors.accentPurple
            ) {
                router.navigate(to: .album)
            }
            
            ListCard(
                title: "Secret Contacts",
                subtitle: "0 contacts",
                iconName: "person.crop.circle.badge.checkmark",
                iconColor: AppColors.accentBlue
            ) {
                router.navigate(to: .contacts)
            }
        }
    }
    
    // MARK: - Protection
    
    private var protectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Protection")
                .subtitleMStyle()
            
            SectionCard {
                VStack(spacing: 0) {
                    protectionRow(
                        title: "Set Passcode",
                        iconName: "lock.fill",
                        isEnabled: false
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.leading, 60)
                    
                    protectionToggleRow(
                        title: "Face ID",
                        iconName: "faceid",
                        isEnabled: true
                    )
                }
            }
        }
    }
    
    private func protectionRow(title: String, iconName: String, isEnabled: Bool) -> some View {
        Button {
            // TODO: Handle action
        } label: {
            HStack(spacing: AppSpacing.spacingIconText) {
                Image(systemName: iconName)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accentPurple)
                    .frame(width: 40)
                
                Text(title)
                    .font(AppTypography.subtitleM)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textTertiary.opacity(0.5))
            }
            .padding(.horizontal, AppSpacing.paddingInner)
            .frame(height: AppSpacing.listCardHeight)
        }
    }
    
    private func protectionToggleRow(title: String, iconName: String, isEnabled: Bool) -> some View {
        HStack(spacing: AppSpacing.spacingIconText) {
            Image(systemName: iconName)
                .font(.system(size: 18))
                .foregroundColor(AppColors.accentPurple)
                .frame(width: 40)
            
            Text(title)
                .font(AppTypography.subtitleM)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: .constant(isEnabled))
                .tint(AppColors.accentBlue)
        }
        .padding(.horizontal, AppSpacing.paddingInner)
        .frame(height: AppSpacing.listCardHeight)
    }
    
    // MARK: - Premium Required
    
    private var premiumRequiredView: some View {
        VStack(spacing: AppSpacing.spacingBlock) {
            Spacer()
            
            Image(systemName: "lock.shield.fill")
                .font(.system(size: AppSpacing.iconPermission))
                .foregroundStyle(AppColors.ctaGradient)
            
            Text("Premium Feature")
                .titleMStyle()
            
            Text("Secret Space is available with Premium subscription. Protect your private photos, videos and contacts.")
                .bodyMStyle()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            PrimaryButton(title: "Start Free Trial") {
                router.showPaywall(source: "secret_space")
            }
            .padding(.horizontal, AppSpacing.paddingOuter)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Preview

struct SecretSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SecretSpaceView()
        }
    }
}

