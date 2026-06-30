import SwiftUI

struct YesterdayComparisonCard: View {
    let yesterday: YesterdayData
    let todayHigh: Double
    let todayLow: Double
    let currentTemp: Double

    var delta: Double { currentTemp - yesterday.high }
    var isWarmer: Bool { delta > 0 }

    var summaryText: String {
        let abs = Int(abs(delta).rounded())
        if abs == 0 { return "Same temperature as yesterday" }
        let direction = isWarmer ? "warmer" : "cooler"
        return "Today is \(abs)° \(direction) than yesterday"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Text("YESTERDAY VS TODAY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider().background(Color.white.opacity(0.3)).padding(.horizontal, 16)

            HStack(spacing: 0) {
                // Yesterday column
                VStack(spacing: 6) {
                    Text("Yesterday")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    Text("H: \(Int(yesterday.high.rounded()))°")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text("L: \(Int(yesterday.low.rounded()))°")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)

                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 1, height: 70)

                // Delta column
                VStack(spacing: 4) {
                    Image(systemName: isWarmer ? "thermometer.sun.fill" : "thermometer.snowflake")
                        .font(.system(size: 24))
                        .foregroundColor(isWarmer ? Color(red: 1, green: 0.4, blue: 0.2) : Color(red: 0.3, green: 0.7, blue: 1))
                    Text(delta >= 0 ? "+\(Int(delta.rounded()))°" : "\(Int(delta.rounded()))°")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(isWarmer ? Color(red: 1, green: 0.4, blue: 0.2) : Color(red: 0.3, green: 0.7, blue: 1))
                }
                .frame(maxWidth: .infinity)

                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 1, height: 70)

                // Today column
                VStack(spacing: 6) {
                    Text("Today")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    Text("H: \(Int(todayHigh.rounded()))°")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text("L: \(Int(todayLow.rounded()))°")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)

            Divider().background(Color.white.opacity(0.3)).padding(.horizontal, 16)

            Text(summaryText)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.85))
                .padding(16)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
