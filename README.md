# MusicStore

A little SwiftUI app for searching songs and playing their 30-second previews, built on top of the [iTunes Search API](https://performance-partners.apple.com/search-api). Has a proper queue, a mini player docked to the tab bar, and a full player sheet you can expand.

Mostly built this to play around with `AVPlayer`, `@Observable`, and a VIPER-ish layered setup without going overboard on abstraction.

## What it does

- Search by artist or track name (debounced 500ms!)
- Streams previews with `AVPlayer` which auto-advances to the next track when one finishes
- Mini player pinned to the tab bar, tap it to expand into a full player
- Play/pause, next/previous, and a scrubber you can actually drag
- Handles loading / error (with retry!) / empty states on the results list
- Artwork loads async with a placeholder so the list doesn't jump around

## Getting it running

You'll need Xcode 26+, iOS 26+, Swift 6. No third-party deps, so just open and run.

```sh
git clone https://github.com/mrandika/ios-musicstore.git
cd ios-musicstore
```

Open `MusicStore.xcodeproj`, pick the `MusicStore` scheme, pick a simulator, hit run.

Prefer the CLI:

```sh
xcodebuild build \
  -project MusicStore.xcodeproj \
  -scheme MusicStore \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO
```

Or if you just want to poke at it without building anything, grab a prebuilt `.app` from [Releases](https://github.com/mrandika/ios-musicstore/releases) and drag it onto a running simulator.

## How it's put together

Roughly VIPER, one direction of dependencies:

```
View (SwiftUI) -> Presenter -> Interactor -> Repository -> APIClient -> iTunes Search API
```

- **View** - just renders state, forwards intents up (search, play, seek). Doesn't know anything about business logic.
- **Presenter** - `@Observable` class, owns the screen's state (`isLoading`, `error`, `musics`), talks to the interactor.
- **Interactor** - the actual business logic, no SwiftUI/UIKit imports allowed in here.
- **Repository** - turns API responses into domain models via a mapper.
- **APIClient** - generic, `Sendable`, builds requests off `APIService` values, throws typed `APIError`s (bad URL, transport failure, bad status code, decode failure - whatever went wrong, you get a real case for it not just a generic error).

Wiring is manual, no DI framework:

- `DependencyContainer` is a plain register/resolve container.
- `MusicsContainer` registers everything a feature needs; `MusicsResolver` pulls it back out.
- `Injection` + `MusicsPresenterFactory` build presenters so views never touch concrete types directly.

Playback is the one bit of genuinely shared state in the app, there's a single `AudioPlayerManager` (`@Observable`, `@MainActor`) sitting in the environment, and the mini player / expanded player / list all just observe it.

## Where things live

```
MusicStore/
├── Application/          # app entry point, DI wiring, factories, global managers
│   ├── Factory/          # presenter factories
│   └── Managers/         # AudioPlayerManager lives here
├── Core/                 # API client, DI container, errors, shared models
│   ├── API/              # APIClient, APIService, APIConfiguration
│   ├── DI/               # DependencyContainer
│   ├── Domain/           # shared mappers
│   ├── Error/            # APIError
│   └── HTTP/             # HTTPMethod
├── Design/               # design system, atomic-design-ish
│   ├── Tokens/           # Spacing, FontSize, FontWeight, CornerRadius
│   ├── Atoms/            # RemoteImageView, StyledText, ImageButtonLabel, ...
│   ├── Molecules/        # BadgeView
│   ├── Organisms/        # SongItem, SongScrubberView, ...
│   ├── Templates/        # MiniPlayerView, ExpandedPlayerView, SongItem
│   └── View Modifier/    # StateViewModifier (loading/error/empty)
├── Feature/
│   └── Musics/           # data layer (API service, repository, response) + domain (interactor, model, mapper)
├── View/
│   └── Music List/       # MusicListView + MusicListPresenter
└── Resources/            # assets, app icon, accent color
```

## Tests

Using Swift Testing (not XCTest, except for the UI tests), covers URL building, HTTP methods, decoding, error mapping. Networking's stubbed out with a `MockURLProtocol`/`MockURLSession` pair so nothing actually hits the network during tests.

```sh
xcodebuild test \
  -project MusicStore.xcodeproj \
  -scheme MusicStore \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  CODE_SIGNING_ALLOWED=NO
```

## CI

`.github/workflows/ios.yml` runs on every push/PR to `main` ! Xcode 26 on a `macos-26` runner, installs `xcbeautify`, resolves packages, grabs whatever simulator's available, builds, runs tests, and uploads the `.xcresult` so you can dig into failures without re-running locally.

## API

No auth needed, it's just:

```
GET https://itunes.apple.com/search?term=<query>&entity=song
```
