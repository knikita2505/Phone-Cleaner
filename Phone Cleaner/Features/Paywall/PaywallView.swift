import SwiftUI

/// Paywall - экран подписки
struct PaywallView: View {
    let source: String
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    @State private var selectedPlan: PlanType = .yearly
    @State private var isTrialEnabled: Bool = true
    
    enum PlanType: String, CaseIterable {
        case weekly = "Weekly"
        case yearly = "Yearly"
    }
    
    var body: some View {
        ZStack {
            // Aurora Background
            auroraBackground
            
            VStack(spacing: 0) {
                // Close Button
                closeButton
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.spacingBlock) {
                        // Header
                        headerSection
                        
                        // Benefits
                        benefitsSection
                        
                        // Trial Toggle
                        trialToggleSection
                        
                        // Plans
                        plansSection
                        
                        // CTA
                        ctaSection
                        
                        // Terms
                        termsSection
                    }
                    .padding(.horizontal, AppSpacing.paddingOuter)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            AnalyticsService.shared.logPaywallShown(source: source)
        }
    }
    
    // MARK: - Aurora Background
    
    private var auroraBackground: some View {
        ZStack {
            AppColors.backgroundPrimary
            
            // Aurora gradients
            Circle()
                .fill(AppColors.accentPurple.opacity(0.3))
                .blur(radius: 100)
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(AppColors.accentBlue.opacity(0.2))
                .blur(radius: 120)
                .frame(width: 400, height: 400)
                .offset(x: 150, y: -100)
            
            // Bottom fade
            LinearGradient(
                colors: [Color.clear, AppColors.backgroundPrimary],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 400)
            .offset(y: 200)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Close Button
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                AnalyticsService.shared.logPaywallSkip()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textTertiary)
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, AppSpacing.paddingOuter)
        .padding(.top, 8)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // App Icon placeholder
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.ctaGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                )
            
            Text("Clean up your iPhone\nfast & easy")
                .font(AppTypography.titleL)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Benefits
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            benefitRow(icon: "square.on.square", text: "Find & remove duplicates")
            benefitRow(icon: "video.fill", text: "Compress large videos")
            benefitRow(icon: "lock.fill", text: "Secret album & contacts")
            benefitRow(icon: "battery.100", text: "Battery tips & device health")
        }
        .padding(AppSpacing.paddingInnerLarge)
        .background(Color.white.opacity(0.05))
        .cornerRadius(AppSpacing.radiusCard)
    }
    
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.accentBlue)
                .frame(width: 24)
            
            Text(text)
                .font(AppTypography.bodyL)
                .foregroundColor(AppColors.textSecondary)
        }
    }
    
    // MARK: - Trial Toggle
    
    private var trialToggleSection: some View {
        HStack {
            Text("Free Trial Enabled")
                .font(AppTypography.subtitleM)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isTrialEnabled)
                .tint(AppColors.accentBlue)
                .onChange(of: isTrialEnabled) { _ in
                    AnalyticsService.shared.logEvent("paywall_trial_toggle")
                }
        }
        .padding(AppSpacing.paddingInner)
        .background(Color.white.opacity(0.05))
        .cornerRadius(AppSpacing.radiusButton)
    }
    
    // MARK: - Plans
    
    private var plansSection: some View {
        VStack(spacing: 12) {
            // Yearly Plan
            PlanCard(
                title: "Yearly",
                price: "$34.99/year",
                subtitle: isTrialEnabled ? "7 days free, then $0.67/week" : "$0.67/week",
                badge: "Most Popular",
                isSelected: selectedPlan == .yearly
            ) {
                selectedPlan = .yearly
                AnalyticsService.shared.logPaywallPlanSelected(plan: "yearly")
            }
            
            // Weekly Plan
            PlanCard(
                title: "Weekly",
                price: "$6.99/week",
                subtitle: isTrialEnabled ? "7 days free trial" : "Billed weekly",
                badge: nil,
                isSelected: selectedPlan == .weekly
            ) {
                selectedPlan = .weekly
                AnalyticsService.shared.logPaywallPlanSelected(plan: "weekly")
            }
        }
    }
    
    // MARK: - CTA
    
    private var ctaSection: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: isTrialEnabled ? "Try for Free" : "Continue",
                action: {
                    // TODO: Implement purchase
                    Task {
                        // Purchase logic will go here
                    }
                },
                isLoading: subscriptionService.isLoading
            )
            
            if isTrialEnabled {
                Text("Cancel anytime. No commitment.")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
        }
    }
    
    // MARK: - Terms
    
    private var termsSection: some View {
        HStack(spacing: 16) {
            Button("Terms of Use") {
                // TODO: Open terms
            }
            .font(AppTypography.caption)
            .foregroundColor(AppColors.textTertiary.opacity(0.6))
            
            Button("Privacy Policy") {
                // TODO: Open privacy
            }
            .font(AppTypography.caption)
            .foregroundColor(AppColors.textTertiary.opacity(0.6))
            
            Button("Restore") {
                Task {
                    await subscriptionService.restorePurchases()
                }
            }
            .font(AppTypography.caption)
            .foregroundColor(AppColors.textTertiary.opacity(0.6))
        }
        .padding(.top, 8)
    }
}

/// Plan Selection Card
struct PlanCard: View {
    let title: String
    let price: String
    let subtitle: String
    let badge: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(AppTypography.subtitleL)
                            .foregroundColor(AppColors.textPrimary)
                        
                        if let badge = badge {
                            Text(badge)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.success)
                                .cornerRadius(6)
                        }
                    }
                    
                    Text(subtitle)
                        .font(AppTypography.bodyM)
                        .foregroundColor(AppColors.textTertiary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(price)
                        .font(AppTypography.subtitleM)
                        .foregroundColor(AppColors.textPrimary)
                }
                
                // Radio Button
                Circle()
                    .stroke(isSelected ? AppColors.accentBlue : AppColors.textTertiary.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(isSelected ? AppColors.accentBlue : Color.clear)
                            .frame(width: 14, height: 14)
                    )
            }
            .padding(AppSpacing.paddingInner)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.radiusButton)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppSpacing.radiusButton)
                            .stroke(
                                isSelected ? AppColors.accentBlue : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - Preview

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(source: "preview")
    }
}

