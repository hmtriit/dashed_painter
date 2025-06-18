# Changelog

All notable changes to the `flutter_dash_painter` package will be documented here.

This project adheres to [Semantic Versioning](https://semver.org/).

---

## [1.0.2] - 2025-06-18

### Fixed
- Export issues related to main `dashed_painter.dart` file
- Minor formatting updates in API docs

### Added
- Unit tests and widget tests for `DashedPainter` and `DashedDecoration`
- Benchmarks via `BenchmarkPainter` example

---

## [1.0.1] - 2025-06-17

### Fixed
- Minor export issues with internal files
- Resolved missing documentation in public APIs

### Added
- Added DartDoc comments for pub.dev
- Stable API entry point via `lib/dashed_painter.dart`

---

## [1.0.0] - 2025-06-17

🎉 **Initial release**

### Added
- Core painter (`DashedPainter`) to render dashed lines using Canvas
- Support for:
  - Straight lines (horizontal/vertical)
  - Circle shapes (`addOval`)
  - Rounded rectangles (`addRRect`)
- Fully customizable:
  - `step`: dash length
  - `span`: space between dashes
  - `pointCount`: number of dots per dash
  - `pointWidth`: length of each dot
- `DashedDecoration` to easily apply dashed borders to `Container`
- Supports `color` and `gradient` (e.g. `SweepGradient`)

---
