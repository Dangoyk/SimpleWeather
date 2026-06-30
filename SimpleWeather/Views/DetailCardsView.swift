import SwiftUI

struct DetailCardsView: View {
    let feelsLike: Double
    let humidity: Int
    let uvIndex: Double
    let windSpeed: Double
    let visibility: Double

    var uvLabel: String {
        switch Int(uvIndex) {
        case 0...2: return "Low"
        case 3...5: return "Moderate"
        case 6...7: return "High"
        case 8...10: return "Very High"
        default: return "Extreme"
        }
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            DetailCard(icon: "thermometer.medium", label: "FEELS LIKE", value: "\(Int(feelsLike.rounded()))°", detail: feelsLike > 90 ? "Hot out there." : feelsLike < 32 ? "Feels freezing." : "Similar to actual.")
            DetailCard(icon: "humidity.fill", label: "HUMIDITY", value: "\(humidity)%", detail: humidity > 70 ? "Muggy conditions." : humidity < 30 ? "Dry air." : "Comfortable.")
            DetailCard(icon: "sun.max.fill", label: "UV INDEX", value: "\(Int(uvIndex))", detail: uvLabel)
            DetailCard(icon: "wind", label: "WIND", value: "\(Int(windSpeed)) mph", detail: windSpeed > 25 ? "Very windy." : windSpeed > 10 ? "Breezy." : "Light wind.")
            DetailCard(icon: "eye.fill", label: "VISIBILITY", value: String(format: "%.1f mi", visibility), detail: visibility > 5 ? "Clear visibility." : "Reduced visibility.")
        }
    }
}

struct DetailCard: View {
    let icon: String
    let label: String
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            Text(value)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
            Spacer()
            Text(detail)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
