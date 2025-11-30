import SwiftUI
import UIKit

/// Secondary Button - вторичная кнопка с рамкой
/// Border: rgba(255,255,255,0.2), Transparent fill, Corner radius: 16pt
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                action()
            }
        }) {
            Text(title)
                .font(AppTypography.buttonSecondary)
                .foregroundColor(isDisabled ? AppColors.textTertiary : AppColors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: AppSpacing.buttonHeightSecondary)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.radiusButton)
                        .stroke(Color.white.opacity(isDisabled ? 0.1 : 0.2), lineWidth: 1)
                )
        }
        .disabled(isDisabled)
    }
}

/// Ghost / Minimal Button - текстовая кнопка без фона
struct GhostButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            Text(title)
                .font(AppTypography.buttonSecondary)
                .foregroundColor(AppColors.textSecondary.opacity(0.7))
        }
    }
}

// MARK: - Preview

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                SecondaryButton(title: "Skip for now") {
                    print("Tapped")
                }
                
                SecondaryButton(title: "Disabled", action: {}, isDisabled: true)
                
                GhostButton(title: "Terms & Privacy") {
                    print("Tapped")
                }
            }
            .padding()
        }
    }
}

