# Flutter Meal & Student

**A Semester 3 Flutter app that pairs a seafood recipe browser with a student record manager.**

The app uses a persistent bottom navigation bar to switch between the student roster, the meal
catalogue and appearance settings. Riverpod drives every screen, and the Material 3 theme is
rebuilt from the selected accent colour and light/dark mode.

Built as coursework for the mobile development module at the National University of Management.

## What it does

### Meal catalogue

- Loads seafood recipes from [TheMealDB](https://www.themealdb.com/) (`filter.php?c=Seafood`).
- Responsive grid with cached network artwork, skeleton placeholders while loading and pull to
  refresh.
- A scroll-triggered floating button jumps back to the top of the grid.
- Tapping a card opens a detail screen with the recipe image, area, category, instructions and
  ingredient/measure pairs.

### Student roster

- Lists students from a local REST API and supports pull to refresh.
- Deletes a record after a confirmation dialog, keeping the current list and showing feedback if
  the request fails.
- Adds a student through a validated form, with a blocking progress overlay while the request is
  in flight.

### Appearance

- Light and dark mode switch.
- Fifteen accent colours that re-seed the Material 3 colour scheme immediately.
- Both choices are restored on launch through `flutter_secure_storage`.

## Run locally

The manifest declares Dart `^3.10.4`. Use a Flutter installation that satisfies that constraint
and the toolchain for your target platform.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

The meal catalogue needs internet access only. The student tab expects the companion API
described below.

### Student API

`lib/services/base_url.dart` selects the host per platform:

| Platform | Base URL |
| --- | --- |
| Android emulator | `http://10.0.2.2:8000` |
| Web, iOS, macOS, Windows, Linux | `http://127.0.0.1:8000` |

The service calls:

```text
GET    /api/students        -> [{ "id": 1, "full_name": "..." }]
POST   /api/students        -> { "full_name": "..." }  (expects 201)
DELETE /api/students/{id}
```

Without that service the student tab shows its error state; the rest of the app still works.

## Stack and source map

| Area | Implementation |
| --- | --- |
| Interface | Flutter, Dart and Material 3 |
| State | Riverpod `AsyncNotifier` providers |
| Navigation | `persistent_bottom_nav_bar_v2` plus named routes |
| Requests | `http` with 10-second timeouts and `compute` parsing |
| Media | `cached_network_image` |
| Loading | `skeletonizer` |
| Preferences | `flutter_secure_storage` |

```text
lib/
  main.dart                     ProviderScope entry point
  apps/my_app.dart              Theme, accent list and named routes
  models/                       Meal, meal detail and student JSON models
  providers/                    Meal, student, theme and accent state
  screens/
    main_screen.dart            Bottom navigation shell
    meal_screen.dart            Recipe grid and refresh
    detail_screen.dart          Recipe detail
    student_screen.dart         Student list and delete
    student_add_screen.dart     Add-student form
    settings_screen.dart        Theme and accent controls
  services/                     TheMealDB and student API clients
  utils/                        Shared snackbar and dialog helpers
test/
  widget_test.dart              App smoke test
```

## Notes and limitations

- The student feature is a client for a separate API. This repository does not include that
  backend.
- Meal data, artwork and availability belong to TheMealDB.
