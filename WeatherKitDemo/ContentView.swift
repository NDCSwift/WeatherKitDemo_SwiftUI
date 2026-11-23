import SwiftUI
import WeatherKit

/// One list: the error (if any), Now, the next 24 hours, ten days, and Apple's attribution at the foot.
///
/// `import WeatherKit` is needed here too: this file reads properties off WeatherKit's own types (`temperature`,
/// `symbolName`), and new Xcode projects turn on Member Import Visibility, which wants the module imported in every
/// file that uses its members.
struct ContentView: View {
    /// The view owns one model, kept in `@State`, so it's created once and lives as long as the screen does.
    @State private var model = WeatherModel()

    var body: some View {
        NavigationStack {
            List {
                if let errorMessage = model.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                if let current = model.current {
                    Section("Now") {
                        HStack {
                            Image(systemName: current.symbolName)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(current.temperature.rounded)
                                    .font(.title)
                                Text(current.condition.description)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                if !model.hourly.isEmpty {
                    Section("Next 24 hours") {
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                // Hours have no id of their own; each one's date is unique, so that tells them apart.
                                ForEach(model.hourly, id: \.date) { hour in
                                    VStack(spacing: 6) {
                                        Text(hour.date.formatted(.dateTime.hour()))
                                            .font(.caption)
                                        Image(systemName: hour.symbolName)
                                        Text(hour.temperature.rounded)
                                    }
                                }
                            }
                        }
                    }
                }

                if !model.daily.isEmpty {
                    Section("10 days") {
                        ForEach(model.daily, id: \.date) { day in
                            HStack {
                                Text(day.date.formatted(.dateTime.weekday(.abbreviated)))
                                    .frame(width: 44, alignment: .leading)
                                Image(systemName: day.symbolName)
                                    .frame(width: 30)
                                Text(day.precipitationChance.formatted(.percent))
                                    .foregroundStyle(.blue)
                                Spacer()
                                Text(day.lowTemperature.rounded)
                                    .foregroundStyle(.secondary)
                                Text(day.highTemperature.rounded)
                            }
                        }
                    }
                }

                if let attribution = model.attribution {
                    AttributionView(attribution: attribution)
                }
            }
            .navigationTitle("Cupertino")
            // .task, not a button or onAppear: the async call belongs to the view's lifetime, and SwiftUI cancels it
            // if the view goes away before the weather comes back.
            .task {
                await model.load()
            }
        }
    }
}

#Preview {
    ContentView()
}
