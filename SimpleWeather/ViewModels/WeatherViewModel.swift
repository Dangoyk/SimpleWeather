import Foundation
import CoreLocation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var currentTemp: Double = 0
    @Published var feelsLike: Double = 0
    @Published var condition: String = ""
    @Published var weathercode: Int = 0
    @Published var todayHigh: Double = 0
    @Published var todayLow: Double = 0
    @Published var windSpeed: Double = 0
    @Published var humidity: Int = 0
    @Published var uvIndex: Double = 0
    @Published var visibility: Double = 0

    @Published var hourlyForecast: [HourlyForecastItem] = []
    @Published var dailyForecast: [DailyForecastItem] = []
    @Published var yesterday: YesterdayData?

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = WeatherService()
    private var cancellables = Set<AnyCancellable>()

    var comparisonDelta: Double? {
        guard let y = yesterday else { return nil }
        return currentTemp - y.high
    }

    var comparisonText: String? {
        guard let delta = comparisonDelta else { return nil }
        let abs = Int(abs(delta).rounded())
        if abs == 0 { return "Same temp as yesterday" }
        let direction = delta > 0 ? "warmer" : "cooler"
        return "\(abs)° \(direction) than yesterday"
    }

    var comparisonArrow: String? {
        guard let delta = comparisonDelta else { return nil }
        if abs(delta) < 0.5 { return "minus" }
        return delta > 0 ? "arrow.up" : "arrow.down"
    }

    func load(location: CLLocation, cityName: String) {
        self.cityName = cityName
        isLoading = true
        errorMessage = nil

        Task {
            do {
                async let forecastTask = service.fetchForecast(for: location)
                async let yesterdayTask = service.fetchYesterday(for: location)

                let (forecast, archive) = try await (forecastTask, yesterdayTask)
                apply(forecast: forecast, archive: archive)
            } catch {
                self.errorMessage = "Couldn't load weather. Check your connection."
                print("Weather fetch error: \(error)")
            }
            self.isLoading = false
        }
    }

    private func apply(forecast: ForecastResponse, archive: ArchiveResponse) {
        let current = forecast.current
        currentTemp = current.temperature2m
        feelsLike = current.apparentTemperature
        weathercode = current.weathercode
        condition = weatherConditionText(for: current.weathercode)
        windSpeed = current.windspeed10m
        humidity = current.relativehumidity2m
        uvIndex = current.uvIndex
        visibility = current.visibility / 5280 // convert feet to miles

        todayHigh = forecast.daily.temperature2mMax.first ?? 0
        todayLow = forecast.daily.temperature2mMin.first ?? 0

        if let yHigh = archive.daily.temperature2mMax.first,
           let yLow = archive.daily.temperature2mMin.first,
           let yFeels = archive.daily.apparentTemperatureMax.first {
            yesterday = YesterdayData(high: yHigh, low: yLow, feelsLikeHigh: yFeels)
        }

        buildHourly(forecast: forecast)
        buildDaily(forecast: forecast)
    }

    private func buildHourly(forecast: ForecastResponse) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "ha"

        var items: [HourlyForecastItem] = []
        for (i, timeStr) in forecast.hourly.time.enumerated() {
            guard i < forecast.hourly.temperature2m.count,
                  i < forecast.hourly.weathercode.count,
                  let date = formatter.date(from: timeStr),
                  date >= now else { continue }

            let label: String
            if items.isEmpty {
                label = "Now"
            } else {
                label = timeFormatter.string(from: date).lowercased()
            }

            items.append(HourlyForecastItem(
                hour: label,
                temperature: forecast.hourly.temperature2m[i],
                weathercode: forecast.hourly.weathercode[i]
            ))
            if items.count == 24 { break }
        }
        hourlyForecast = items
    }

    private func buildDaily(forecast: ForecastResponse) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"

        let today = formatter.string(from: Date())

        dailyForecast = forecast.daily.time.enumerated().compactMap { (i, dateStr) in
            guard i < forecast.daily.temperature2mMax.count,
                  i < forecast.daily.temperature2mMin.count,
                  i < forecast.daily.weathercode.count else { return nil }

            let label: String
            if dateStr == today {
                label = "Today"
            } else if let date = formatter.date(from: dateStr) {
                label = dayFormatter.string(from: date)
            } else {
                label = dateStr
            }

            return DailyForecastItem(
                dayName: label,
                weathercode: forecast.daily.weathercode[i],
                tempMin: forecast.daily.temperature2mMin[i],
                tempMax: forecast.daily.temperature2mMax[i],
                precipitationSum: forecast.daily.precipitationSum[i]
            )
        }
    }
}
