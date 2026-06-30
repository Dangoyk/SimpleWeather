import SwiftUI

struct WeatherView: View {
    @StateObject private var vm = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()

    private var currentHour: Int {
        Calendar.current.component(.hour, from: Date())
    }

    private var gradientColors: [Color] {
        let hexColors = backgroundGradientColors(for: vm.weathercode, hour: currentHour)
        return hexColors.map { Color(hex: $0) }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1), value: vm.weathercode)

            content
        }
        .onReceive(locationManager.$location.compactMap { $0 }) { loc in
            vm.load(location: loc, cityName: locationManager.cityName)
        }
        .onReceive(locationManager.$cityName) { name in
            if !name.isEmpty && name != "Loading..." {
                vm.cityName = name
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }

    @ViewBuilder
    private var content: some View {
        if vm.isLoading && vm.currentTemp == 0 {
            loadingView
        } else if let error = vm.errorMessage, vm.currentTemp == 0 {
            errorView(message: error)
        } else {
            mainScrollView
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .scaleEffect(1.5)
            Text("Loading weather...")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.7))
            Text(message)
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") {
                locationManager.requestLocation()
            }
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }

    private var mainScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CurrentConditionsView(
                    cityName: vm.cityName,
                    temp: vm.currentTemp,
                    feelsLike: vm.feelsLike,
                    condition: vm.condition,
                    high: vm.todayHigh,
                    low: vm.todayLow,
                    comparisonText: vm.comparisonText,
                    comparisonArrow: vm.comparisonArrow,
                    delta: vm.comparisonDelta
                )
                .padding(.top, 60)
                .padding(.bottom, 8)

                if !vm.hourlyForecast.isEmpty {
                    HourlyForecastView(items: vm.hourlyForecast)
                }

                if let yesterday = vm.yesterday {
                    YesterdayComparisonCard(
                        yesterday: yesterday,
                        todayHigh: vm.todayHigh,
                        todayLow: vm.todayLow,
                        currentTemp: vm.currentTemp
                    )
                }

                if !vm.dailyForecast.isEmpty {
                    DailyForecastView(items: vm.dailyForecast)
                }

                DetailCardsView(
                    feelsLike: vm.feelsLike,
                    humidity: vm.humidity,
                    uvIndex: vm.uvIndex,
                    windSpeed: vm.windSpeed,
                    visibility: vm.visibility
                )

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
        }
        .refreshable {
            locationManager.requestLocation()
        }
    }
}

// MARK: - Color from hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
