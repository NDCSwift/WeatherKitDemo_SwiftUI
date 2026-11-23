import SwiftUI
import WeatherKit

/// The credit Apple requires before you show its weather: the Apple Weather mark and a link to the other data
/// sources. No credit, no shipping. There's no preview: it can't be drawn without a real attribution from the network.
struct AttributionView: View {
    let attribution: WeatherAttribution
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            // combinedMarkDarkURL is the white mark for dark mode; combinedMarkLightURL is the black one for light
            // mode. Swap them and the mark disappears into the background.
            AsyncImage(url: colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL) { image in
                // A downloaded image arrives at its own size, so it's made resizable to fit the frame below.
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 12)

            Link("Other data sources", destination: attribution.legalPageURL)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}
