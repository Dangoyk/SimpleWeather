# SimpleWeather

A native SwiftUI iOS weather app that matches the look and feel of Apple Weather, with a standout feature: **comparison to yesterday's weather** shown prominently right on the main screen.

## Features

- Current temperature with condition and high/low
- **"X° warmer/cooler than yesterday" badge** — inline on the current temperature
- **Yesterday vs Today comparison card** — side-by-side high/low with delta
- 24-hour hourly forecast strip
- 10-day forecast with animated temperature bars
- Detail cards: Feels Like, Humidity, UV Index, Wind, Visibility
- Dynamic background gradient based on time of day and weather conditions
- Auto-detects location via CoreLocation
- Pull-to-refresh

## Data Source

Uses [Open-Meteo](https://open-meteo.com/) — free, no API key required.
- Forecast: `api.open-meteo.com/v1/forecast`
- Historical (yesterday): `archive-api.open-meteo.com/v1/archive`

## Setup

1. Clone this repo
2. Open `SimpleWeather.xcodeproj` in Xcode 15+
3. Select your target device or simulator
4. Build and run (⌘R)
5. Grant location permission when prompted

**Requirements**: Xcode 15+, iOS 16+, macOS Ventura or later

## Architecture

- **MVVM** with SwiftUI + Combine
- `WeatherViewModel` — fetches forecast and yesterday data concurrently with `async let`
- `WeatherService` — Open-Meteo API calls
- `LocationManager` — CoreLocation wrapper with reverse geocoding
