# Security guidance

Flutter Meal & Student is coursework, not a supported release. It reads public recipe data from
TheMealDB and talks to a local student API over plain HTTP. This document is not a security
audit.

## Data and transport

- The student client sends and receives names over cleartext HTTP on loopback or the Android
  emulator host alias. Do not point it at a public host without adding TLS.
- The app stores no credentials and ships no API keys, environment files or tokens.
- Appearance choices are written to platform secure storage under the `ThemeNotifier` and
  `ColorNotifier` keys. They are UI preferences only; do not store credentials there.
- Recipe text and artwork are third-party content. Treat instructions and links as external
  data, not maintainer guarantees.

## Distribution

Android release builds use the default debug signing configuration and the example application
ID from the Flutter template. Review signing, identifiers and distribution before publishing a
store release. Keep signing keys and credentials out of commits.

## Reporting

For ordinary defects, provide the affected screen, Flutter and package versions, target
platform and a minimal reproduction. Redact private details from screenshots and logs.

For sensitive concerns, use a verified private maintainer channel if available, or ask for one
without publishing sensitive details. No dedicated security address or response deadline is
confirmed by this repository.
