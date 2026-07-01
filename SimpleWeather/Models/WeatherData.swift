import Foundation

// MARK: - Open-Meteo Forecast Response

struct ForecastResponse: Codable {
    let current: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let temperature2m: Double
    let apparentTemperature: Double
    let weathercode: Int
    let windspeed10m: Double
    let relativehumidity2m: Int
    let uvIndex: Double
    let visibility: Double
    let surfacePressure: Double

    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case weathercode
        case windspeed10m = "windspeed_10m"
        case relativehumidity2m = "relativehumidity_2m"
        case uvIndex = "uv_index"
        case visibility
        case surfacePressure = "surface_pressure"
    }
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature2m: [Double]
    let weathercode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weathercode
    }
}

struct DailyWeather: Codable {
    let time: [String]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let weathercode: [Int]
    let precipitationSum: [Double]
    let precipitationProbabilityMax: [Int]
    let sunrise: [String]
    let sunset: [String]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case weathercode
        case precipitationSum = "precipitation_sum"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case sunrise
        case sunset
    }
}

// MARK: - Open-Meteo Archive Response (Yesterday)

struct ArchiveResponse: Codable {
    let daily: ArchiveDaily
}

struct ArchiveDaily: Codable {
    let time: [String]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let apparentTemperatureMax: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case apparentTemperatureMax = "apparent_temperature_max"
    }
}

// MARK: - Domain Models

struct HourlyForecastItem: Identifiable {
    let id = UUID()
    let hour: String
    let temperature: Double
    let weathercode: Int
}

struct DailyForecastItem: Identifiable {
    let id = UUID()
    let dayName: String
    let weathercode: Int
    let tempMin: Double
    let tempMax: Double
    let precipitationSum: Double
    let precipitationProbability: Int
}

struct YesterdayData {
    let high: Double
    let low: Double
    let feelsLikeHigh: Double
}

// MARK: - WMO Weather Code Helpers

func weatherSymbol(for code: Int) -> String {
    switch code {
    case 0: return "sun.max.fill"
    case 1: return "sun.max.fill"
    case 2: return "cloud.sun.fill"
    case 3: return "cloud.fill"
    case 45, 48: return "cloud.fog.fill"
    case 51, 53, 55: return "cloud.drizzle.fill"
    case 61, 63, 65: return "cloud.rain.fill"
    case 71, 73, 75: return "cloud.snow.fill"
    case 77: return "cloud.snow.fill"
    case 80, 81, 82: return "cloud.heavyrain.fill"
    case 85, 86: return "cloud.snow.fill"
    case 95: return "cloud.bolt.fill"
    case 96, 99: return "cloud.bolt.rain.fill"
    default: return "cloud.fill"
    }
}

func weatherConditionText(for code: Int) -> String {
    switch code {
    case 0: return "Clear Sky"
    case 1: return "Mostly Clear"
    case 2: return "Partly Cloudy"
    case 3: return "Overcast"
    case 45: return "Foggy"
    case 48: return "Icy Fog"
    case 51, 53, 55: return "Drizzle"
    case 61, 63, 65: return "Rain"
    case 71, 73, 75: return "Snow"
    case 77: return "Snow Grains"
    case 80, 81, 82: return "Showers"
    case 85, 86: return "Snow Showers"
    case 95: return "Thunderstorm"
    case 96, 99: return "Thunderstorm with Hail"
    default: return "Cloudy"
    }
}

func backgroundGradientColors(for code: Int, hour: Int) -> [String] {
    let isNight = hour < 6 || hour >= 20
    if isNight {
        return ["#0a0e2e", "#1a2a5e"]
    }
    switch code {
    case 0, 1: return ["#1a6bb5", "#4ab0f0"]
    case 2: return ["#2a7bc5", "#6bbfe0"]
    case 3: return ["#4a6580", "#7a95a8"]
    case 45, 48: return ["#5a6570", "#8a9aa5"]
    case 51...65: return ["#3a5570", "#6a8595"]
    case 71...77: return ["#5a7090", "#9ab0c5"]
    case 80...82: return ["#2a4560", "#5a7585"]
    case 95, 96, 99: return ["#1a2535", "#3a4550"]
    default: return ["#2a6095", "#5a90b5"]
    }
}
