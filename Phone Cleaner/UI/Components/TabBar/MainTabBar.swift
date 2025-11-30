import SwiftUI
import UIKit

/// Кастомный TabBar
struct MainTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            }
        }
        .padding(.horizontal, AppSpacing.paddingInner)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            AppColors.backgroundSecondary
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -10)
        )
    }
}

/// Кнопка вкладки
struct TabBarButton: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentBlue : AppColors.textTertiary)
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentBlue : AppColors.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

struct MainTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                MainTabBar(selectedTab: .constant(.clean))
            }
        }
    }
}

