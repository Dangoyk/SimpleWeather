import SwiftUI

struct DailyForecastView: View {
    let items: [DailyForecastItem]

    private var globalMin: Double { items.map(\.tempMin).min() ?? 0 }
    private var globalMax: Double { items.map(\.tempMax).max() ?? 100 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Text("10-DAY FORECAST")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider().background(Color.white.opacity(0.3)).padding(.horizontal, 16)

            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                DailyRow(item: item, globalMin: globalMin, globalMax: globalMax)
                if index < items.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.leading, 16)
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DailyRow: View {
    let item: DailyForecastItem
    let globalMin: Double
    let globalMax: Double

    private var range: Double { globalMax - globalMin }
    private var lowFraction: Double { range > 0 ? (item.tempMin - globalMin) / range : 0 }
    private var highFraction: Double { range > 0 ? (item.tempMax - globalMin) / range : 1 }

    var body: some View {
        HStack(spacing: 12) {
            Text(item.dayName)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 48, alignment: .leading)

            VStack(spacing: 2) {
                Image(systemName: weatherSymbol(for: item.weathercode))
                    .font(.system(size: 22))
                    .symbolRenderingMode(.multicolor)
                if item.precipitationProbability > 0 {
                    Text("\(item.precipitationProbability)%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1))
                }
            }
            .frame(width: 36)

            Text("\(Int(item.tempMin.rounded()))°")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 36, alignment: .trailing)

            // Temperature bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 4)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.3, green: 0.7, blue: 1), Color(red: 1, green: 0.5, blue: 0.1)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: max(4, geo.size.width * (highFraction - lowFraction)),
                            height: 4
                        )
                        .offset(x: geo.size.width * lowFraction)
                }
                .frame(height: 4)
                .frame(maxHeight: .infinity)
            }
            .frame(height: 4)

            Text("\(Int(item.tempMax.rounded()))°")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 36, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
