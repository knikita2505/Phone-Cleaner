import SwiftUI

/// Progress Bar - индикатор прогресса
/// Height: 8pt, Radius: full, Gradient background
struct ProgressBar: View {
    let progress: Double // 0.0 - 1.0
    var gradientColors: [Color] = [Color(hex: "FF8D4D"), Color(hex: "FFD36B")]
    var height: CGFloat = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: height)
                
                // Progress
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: max(0, min(geometry.size.width * progress, geometry.size.width)),
                        height: height
                    )
                    .animation(.easeOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
}

/// Circular Progress Ring - круговой индикатор
struct CircularProgressRing: View {
    let progress: Double // 0.0 - 1.0
    var lineWidth: CGFloat = 12
    var size: CGFloat = 120
    var gradientColors: [Color] = [Color(hex: "FF8D4D"), Color(hex: "FFD36B")]
    
    var body: some View {
        ZStack {
            // Background Ring
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: lineWidth)
            
            // Progress Ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: gradientColors + [gradientColors.first ?? .orange],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.5), value: progress)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ProgressBar(progress: 0.65)
                    .padding(.horizontal)
                
                ProgressBar(
                    progress: 0.3,
                    gradientColors: [AppColors.accentBlue, AppColors.accentPurple]
                )
                .padding(.horizontal)
                
                CircularProgressRing(progress: 0.7)
                
                CircularProgressRing(
                    progress: 0.45,
                    gradientColors: [AppColors.accentBlue, AppColors.accentPurple]
                )
            }
        }
    }
}

