import Foundation
import CoreLocation
import WeatherKit

/// The one object that asks Apple for the weather and holds whatever comes back, so the views never talk to
/// WeatherKit themselves.
///
/// `@Observable`: any view that reads these properties redraws when they change.
@Observable
final class WeatherModel {
    /// Conditions right now. Optional, because until the call comes back there's nothing.
    var current: CurrentWeather?
    /// The next 24 hours, one `HourWeather` each. Starts empty, so the view can check whether there's anything to show.
    var hourly: [HourWeather] = []
    /// Ten days from today, one `DayWeather` each: the day's high, low and chance of rain.
    var daily: [DayWeather] = []
    /// The Apple Weather mark and the legal page Apple requires on screen. Fetched from the network like the rest.
    var attribution: WeatherAttribution?
    /// The first thing this call does without setup is fail, and the failure belongs on screen, not in the console.
    var errorMessage: String?

    /// A fixed spot (Apple Park, Cupertino). Asking for the user's own location is a whole permission flow and a
    /// different video. Swap the coordinates for your own city's.
    private let location = CLLocation(latitude: 37.3349, longitude: -122.0090)

    /// One call for everything: list the pieces you'll show and you get exactly those back, as a tuple.
    ///
    /// - `.current` → `CurrentWeather`
    /// - `.hourly(startDate:endDate:)` → `Forecast<HourWeather>`. Plain `.hourly` returns ~250 hours from the start
    ///   of today, so the range is spelled out.
    /// - `.daily` → `Forecast<DayWeather>`: ten days starting today. Each forecast's `forecast` property is the
    ///   plain array inside.
    ///
    /// If it throws, read the error: `…ServiceProxy.Errors error 0` means the app has no WeatherKit capability;
    /// `…ServiceListener.Errors error 2` means WeatherKit isn't ticked on your App ID's **App Services** tab.
    func load() async {
        do {
            let (current, hourly, daily) = try await WeatherService.shared.weather(
                for: location,
                including: .current,
                .hourly(startDate: .now, endDate: .now.addingTimeInterval(24 * 60 * 60)),
                .daily
            )
            // `self.` because the new local names match the property names.
            self.current = current
            self.hourly = hourly.forecast
            self.daily = daily.forecast
            attribution = try await WeatherService.shared.attribution
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

extension Measurement<UnitTemperature> {
    /// Whole degrees in the user's unit ("18°"). Converting the unit is free; rounding it isn't, so it's written once
    /// here and used for the current, hourly and daily temperatures.
    var rounded: String {
        formatted(.measurement(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(0))))
    }
}
