# Brewery Explorer

A Flutter app for browsing breweries using the public [Open Brewery DB](https://www.openbrewerydb.org/) API.

## Prerequisites

- Flutter SDK compatible with Dart `^3.13.4` (see `pubspec.yaml`)
- An active internet connection (the app calls the Open Brewery DB HTTP API; there is no offline mode)

## How to Run

```bash
flutter pub get
dart run build_runner build
flutter run
```

Run tests with:

```bash
flutter test
```

## What I Completed

- Paginated brewery list showing name, type, and city.
- Brewery detail screen with address, phone number, and website.
- Loading, error, and empty states.
- Layered structure with `data`, `domain`, and `presentation` under `features/breweries/`.
- Dependency injection using `get_it` and `injectable`.
- Typed exceptions and Bloc/Cubit state management.
- Search with debounce using `bloc_concurrency` and `restartable`.
- `BreweryListBloc` unit tests covering loading, errors, empty results, and search. UI and detail-screen coverage is limited.

## What I Left Out

- Map integration with Mapbox.
- Distance-based sorting using Geolocator.
- Offline caching.
- Pixel-perfect UI, authentication, CI/CD, and full test coverage.

I focused on the main requirements and chose search with debounce as my bonus feature.

## Trade-offs

- Used `flutter_bloc` instead of GetX to keep state management explicit and use the Bloc ecosystem for event handling and testing.
- Used a feature-based, layered structure. It adds some boilerplate for a small app, but keeps responsibilities separate.
- Kept the service locator in the app setup and used `BlocProvider` to provide Blocs and Cubits to the UI.

## What I Would Improve

On the current codebase:

- Keep Dio (`CancelToken` / `DioException`) inside the data layer; map cancellations to a typed domain exception so domain and presentation stay HTTP-agnostic.
- Move `TextEditingController` and `ScrollController` out of `BreweryListBloc` and into the UI, so the Bloc only handles events and state.
- Surface pagination failures to the user (today load-more errors only clear `isLoadingMore` with no feedback or retry).

As follow-ups:

- Add distance-based sorting and map integration.
- Cache the last successful list for offline use.
- Add more tests for the detail screen and pagination.
- Improve the search experience with clearer cancellation and loading feedback.
