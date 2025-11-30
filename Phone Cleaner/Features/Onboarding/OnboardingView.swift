import SwiftUI

/// Onboarding - экраны приветствия
struct OnboardingView: View {
    @StateObject private var appState = AppState.shared
    @StateObject private var permissionService = PermissionService.shared
    
    @State private var currentPage = 0
    @State private var showPermissionScreen = false
    @State private var showPaywall = false
    
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            // Aurora Background
            auroraBackground
            
            VStack(spacing: 0) {
                // Skip Button
                skipButton
                
                // Page Content
                TabView(selection: $currentPage) {
                    OnboardingPage1().tag(0)
                    OnboardingPage2().tag(1)
                    OnboardingPage3().tag(2)
                    OnboardingPage4().tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                // Progress Dots
                progressDots
                
                // CTA Button
                PrimaryButton(title: "Continue") {
                    nextPage()
                }
                .padding(.horizontal, AppSpacing.paddingOuter)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showPermissionScreen) {
            PermissionRequestView(
                onComplete: {
                    showPermissionScreen = false
                    showPaywall = true
                },
                onSkip: {
                    showPermissionScreen = false
                    showPaywall = true
                }
            )
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(source: "onboarding")
                .onDisappear {
                    appState.completeOnboarding()
                }
        }
        .onAppear {
            AnalyticsService.shared.logOnboardingStepShown(step: 1)
        }
    }
    
    // MARK: - Aurora Background
    
    private var auroraBackground: some View {
        ZStack {
            AppColors.backgroundPrimary
            
            Circle()
                .fill(Color(hex: "2F3DAF").opacity(0.4))
                .blur(radius: 100)
                .frame(width: 350, height: 350)
                .offset(x: -50, y: -250)
            
            Circle()
                .fill(Color(hex: "6B3BDB").opacity(0.3))
                .blur(radius: 120)
                .frame(width: 400, height: 400)
                .offset(x: 100, y: -150)
            
            Circle()
                .fill(Color(hex: "8B5CFF").opacity(0.2))
                .blur(radius: 80)
                .frame(width: 250, height: 250)
                .offset(x: -80, y: 100)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Skip Button
    
    private var skipButton: some View {
        HStack {
            Spacer()
            if currentPage < totalPages - 1 {
                Button("Skip") {
                    showPermissionScreen = true
                }
                .font(AppTypography.buttonSecondary)
                .foregroundColor(AppColors.textTertiary)
            }
        }
        .padding(.horizontal, AppSpacing.paddingOuter)
        .padding(.top, 8)
        .frame(height: 44)
    }
    
    // MARK: - Progress Dots
    
    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? AppColors.accentBlue : Color.white.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeOut(duration: 0.2), value: currentPage)
            }
        }
        .padding(.bottom, 24)
    }
    
    // MARK: - Actions
    
    private func nextPage() {
        AnalyticsService.shared.logOnboardingStepNext(step: currentPage + 1)
        
        if currentPage < totalPages - 1 {
            currentPage += 1
            AnalyticsService.shared.logOnboardingStepShown(step: currentPage + 1)
        } else {
            showPermissionScreen = true
        }
    }
}

// MARK: - Onboarding Pages

struct OnboardingPage1: View {
    var body: some View {
        OnboardingPageContent(
            iconName: "sparkles",
            iconGradient: [AppColors.accentBlue, AppColors.accentPurple],
            title: "Let's clean up your device",
            subtitle: "Smart scanning for photos, videos, duplicates and system clutter."
        )
    }
}

struct OnboardingPage2: View {
    var body: some View {
        OnboardingPageContent(
            iconName: "photo.stack.fill",
            iconGradient: [AppColors.accentPurple, AppColors.accentLavender],
            title: "Delete the unnecessary.\nKeep the important.",
            subtitle: "We accurately find duplicates, similar photos, Live and blurry shots. You decide what to keep."
        )
    }
}

struct OnboardingPage3: View {
    var body: some View {
        OnboardingPageContent(
            iconName: "bolt.fill",
            iconGradient: [AppColors.warning, Color(hex: "FF9500")],
            title: "Maximum performance\nevery day",
            subtitle: "Smart device analysis: battery health, temperature, large files — everything under control."
        )
    }
}

struct OnboardingPage4: View {
    var body: some View {
        OnboardingPageContent(
            iconName: "checkmark.shield.fill",
            iconGradient: [AppColors.success, Color(hex: "2FB89A")],
            title: "Designed for stable\nand secure operation",
            subtitle: "Your data stays on the device. We don't upload photos or videos to any server."
        )
    }
}

/// Reusable page content
struct OnboardingPageContent: View {
    let iconName: String
    let iconGradient: [Color]
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: iconGradient.map { $0.opacity(0.2) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                
                Image(systemName: iconName)
                    .font(.system(size: 56, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: iconGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 16) {
                Text(title)
                    .font(AppTypography.titleL)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(AppTypography.bodyL)
                    .foregroundColor(AppColors.textSecondary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppSpacing.paddingOuter)
    }
}

// MARK: - Permission Request View

struct PermissionRequestView: View {
    let onComplete: () -> Void
    let onSkip: () -> Void
    
    @StateObject private var permissionService = PermissionService.shared
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Icon
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: AppSpacing.iconPermission, weight: .medium))
                    .foregroundStyle(AppColors.ctaGradient)
                
                VStack(spacing: 16) {
                    Text("Allow access to your\nPhotos & Videos")
                        .font(AppTypography.titleL)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("We use access only to analyze and remove unnecessary files. Everything stays on your device.")
                        .font(AppTypography.bodyL)
                        .foregroundColor(AppColors.textSecondary.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("You can change this later in Settings.")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    PrimaryButton(title: "Enable Photo Access") {
                        Task {
                            AnalyticsService.shared.logOnboardingPermissionRequest()
                            let granted = await permissionService.requestPhotoPermission()
                            if granted {
                                onComplete()
                            } else {
                                onSkip()
                            }
                        }
                    }
                    
                    GhostButton(title: "Skip for now") {
                        onSkip()
                    }
                }
                .padding(.horizontal, AppSpacing.paddingOuter)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

