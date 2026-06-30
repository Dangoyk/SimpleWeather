import SwiftUI

struct CurrentConditionsView: View {
    let cityName: String
    let temp: Double
    let feelsLike: Double
    let condition: String
    let high: Double
    let low: Double
    let comparisonText: String?
    let comparisonArrow: String?
    let delta: Double?

    var body: some View {
        VStack(spacing: 4) {
            Text(cityName)
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(.white)

            HStack(alignment: .top, spacing: 2) {
                Text("\(Int(temp.rounded()))°")
                    .font(.system(size: 96, weight: .thin))
                    .foregroundColor(.white)
            }

            if let text = comparisonText, let arrow = comparisonArrow, let delta = delta {
                ComparisonBadge(text: text, arrow: arrow, isWarmer: delta > 0)
                    .padding(.top, 2)
            }

            Text(condition)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, 4)

            Text("H:\(Int(high.rounded()))°  L:\(Int(low.rounded()))°")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct ComparisonBadge: View {
    let text: String
    let arrow: String
    let isWarmer: Bool

    var badgeColor: Color {
        isWarmer ? Color(red: 1, green: 0.4, blue: 0.2) : Color(red: 0.3, green: 0.7, blue: 1)
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: arrow)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(badgeColor.opacity(0.85))
        .clipShape(Capsule())
    }
}
