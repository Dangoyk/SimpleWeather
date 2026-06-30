import SwiftUI

struct HourlyForecastView: View {
    let items: [HourlyForecastItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("HOURLY FORECAST")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)

            Divider().background(Color.white.opacity(0.3)).padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        HourlyItem(item: item)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct HourlyItem: View {
    let item: HourlyForecastItem

    var body: some View {
        VStack(spacing: 6) {
            Text(item.hour)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .frame(minWidth: 44)

            Image(systemName: weatherSymbol(for: item.weathercode))
                .font(.system(size: 22))
                .symbolRenderingMode(.multicolor)
                .frame(height: 26)

            Text("\(Int(item.temperature.rounded()))°")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(width: 56)
    }
}
