# Contributing to Flutter Meal & Student

Keep changes focused on the meal catalogue, the student roster or the shared appearance
settings. Read the [README](README.md) before adding features or changing dependencies.

## Development

Use the existing lockfile. Keep HTTP access in `lib/services`, screen state in `lib/providers`
and reusable UI helpers in `lib/utils` rather than introducing a new architecture for a small
change.

The student screens depend on an external REST API. Point `lib/services/base_url.dart` at a
running instance before testing add, delete and refresh flows; do not commit machine-specific
hosts or credentials.

## Verification

Run the README's format, analyser and test commands. Report actual results, and distinguish
mocked tests from live API and emulator checks.

For catalogue changes, cover malformed responses, empty results, initial failure, refresh
failure and a successful reload. For student changes, cover validation errors, duplicate
submissions, failed writes and the record that remains when a delete fails. For UI changes,
exercise narrow layouts, long recipe names, large text, both themes and the loading, error and
empty states.

## Pull requests

Explain the problem, the focused change, verification and any remaining gaps. Include
screenshots for visual changes, but remove private account details. Keep generated builds and
unrelated platform changes out of the patch. Follow [SECURITY.md](SECURITY.md) for sensitive
reports.
