import Foundation
import CoreLocation

struct WeatherService {
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()

    func fetchForecast(for location: CLLocation) async throws -> ForecastResponse {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let urlString = "https://api.open-meteo.com/v1/forecast" +
            "?latitude=\(lat)&longitude=\(lon)" +
            "&current=temperature_2m,apparent_temperature,weathercode,windspeed_10m,relativehumidity_2m,uv_index,visibility" +
            "&hourly=temperature_2m,weathercode" +
            "&daily=temperature_2m_max,temperature_2m_min,weathercode,precipitation_sum" +
            "&temperature_unit=fahrenheit&windspeed_unit=mph&timezone=auto" +
            "&forecast_days=10"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(ForecastResponse.self, from: data)
    }

    func fetchYesterday(for location: CLLocation) async throws -> ArchiveResponse {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateStr = ISO8601DateFormatter.yyyyMMdd.string(from: yesterday)
        let urlString = "https://archive-api.open-meteo.com/v1/archive" +
            "?latitude=\(lat)&longitude=\(lon)" +
            "&start_date=\(dateStr)&end_date=\(dateStr)" +
            "&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max" +
            "&temperature_unit=fahrenheit&timezone=auto"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(ArchiveResponse.self, from: data)
    }
}

extension ISO8601DateFormatter {
    static let yyyyMMdd: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        return f
    }()
}
