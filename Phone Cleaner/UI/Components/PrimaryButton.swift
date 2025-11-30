import SwiftUI
import UIKit

/// Primary Button - основная CTA кнопка с градиентом
/// Full width, Height: 56pt, Corner radius: 16pt
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                action()
            }
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(AppTypography.buttonPrimary)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonHeightPrimary)
            .background(
                Group {
                    if isDisabled {
                        Color.gray.opacity(0.5)
                    } else {
                        AppColors.ctaGradient
                    }
                }
            )
            .cornerRadius(AppSpacing.radiusButton)
            .softShadow()
        }
        .disabled(isDisabled || isLoading)
        .scaleEffect(isDisabled ? 1.0 : 1.0)
        .animation(.easeOut(duration: 0.2), value: isDisabled)
    }
}

// MARK: - Button Press Effect

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                PrimaryButton(title: "Continue") {
                    print("Tapped")
                }
                
                PrimaryButton(title: "Loading...", action: {}, isLoading: true)
                
                PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
            }
            .padding()
        }
    }
}

