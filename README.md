# 🌦️ WeatherKitDemo_SwiftUI

Current, hourly and 10-day forecasts from **one WeatherKit call** in SwiftUI, set up right: **the entitlement in your app, WeatherKit on your App ID, and the Apple Weather attribution on screen.**

---

## 🤔 What this is

WeatherKitDemo is a single list for a fixed spot (Apple Park, Cupertino): the weather **now**, a swipeable strip of the **next 24 hours**, and the **next 10 days** with chance of rain, low and high. At the foot sits the Apple Weather mark and an *Other data sources* link, which Apple requires before you show its weather.

The Swift is one call. What makes it work is that the call has to get through **two locks**:

| Lock | Where | What you see while it's shut |
|---|---|---|
| **The entitlement** | In your app: target ▸ Signing & Capabilities ▸ **+ Capability ▸ WeatherKit** (already in [`WeatherKitDemo.entitlements`](WeatherKitDemo/WeatherKitDemo.entitlements)) | `WeatherDaemon.WDSJWTAuthenticatorServiceProxy.Errors error 0` |
| **The App ID** | In your account: Certificates, Identifiers & Profiles ▸ Identifiers ▸ your App ID ▸ WeatherKit ticked on **both** the Capabilities and the **App Services** tab | `WeatherDaemon.WDSJWTAuthenticatorServiceListener.Errors error 2` |

## ✅ Why you'd use it

- **One call, exactly the pieces you need.** [`WeatherModel`](WeatherKitDemo/WeatherModel.swift) asks `WeatherService.shared.weather(for:including:)` for `.current`, `.hourly(startDate:endDate:)` and `.daily` together and gets a typed tuple back.
- **The setup errors decoded.** Error 0 and error 2 show on screen, not in the console, and the comments say which lock each one means.
- **Attribution done properly.** [`AttributionView`](WeatherKitDemo/AttributionView.swift) picks `combinedMarkDarkURL` or `combinedMarkLightURL` by color scheme, so the mark never disappears into the background.
- **Commented line by line**, matching what the video says about each piece.

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Video-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/@NoahDoesCoding)

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding).

---

## 🚀 Getting Started

WeatherKit needs a **paid Apple Developer Program membership**, even in the Simulator. A free (Personal Team) account can't add the capability at all. The membership includes 500,000 calls a month.

### 1. Clone

```bash
git clone https://github.com/NDCSwift/WeatherKitDemo_SwiftUI.git
cd WeatherKitDemo_SwiftUI
```

### 2. Open

```bash
open WeatherKitDemo.xcodeproj
```

### 3. Team

Select the project in the navigator → **Signing & Capabilities** → set **Team** to your **paid** team, not a Personal Team.

### 4. Bundle ID

The bundle identifier is `com.example.NDCWeatherKitDemo3`. **Change it to your own** (e.g. `com.yourname.WeatherKitDemo`): an App ID belongs to one team, and that one is taken. With automatic signing, Xcode registers your new App ID with WeatherKit on its **Capabilities** tab.

### 5. Tick App Services (the second lock)

Go to [Certificates, Identifiers & Profiles ▸ Identifiers](https://developer.apple.com/account/resources/identifiers/list), open your App ID, switch to the **App Services** tab, tick **WeatherKit** and **Save**. Xcode doesn't do this one. It takes a couple of minutes to reach the weather service; until then you'll see error 2.

### 6. Run

Pick an **iPhone** simulator (iOS 17 or later) and press **⌘R**.

## 🛠️ Notes

- **Swap the location.** `WeatherModel` uses a fixed `CLLocation` for Apple Park. Put in your own city's coordinates; asking for the user's location is a separate permission flow.
- **Plain `.hourly` isn't 24 hours.** It returned about 250 hours from the start of today, so the call passes `startDate: .now` and an `endDate` 24 hours out. Plain `.daily` really is 10 days starting today.
- **Don't fetch on every screen.** Calls come out of your monthly allowance: cache what you have and don't ask again for the same piece a minute later.
- **Check the attribution in both appearances.** Flip the simulator between light and dark: the mark switches from the black to the white version.
- **Severe weather alerts** come with their own display rules and aren't covered here.

## 📦 Requirements

- Xcode 27 (the project file uses Xcode 27's format; the Swift files themselves work with Xcode 15 or later)
- iOS 17.0+ deployment target (`@Observable` needs iOS 17)
- A paid Apple Developer Program membership (WeatherKit isn't available to free accounts)
- Swift / SwiftUI
