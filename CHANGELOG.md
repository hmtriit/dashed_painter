# Changelog

All notable changes to the `flutter_dash_painter` package will be documented here.

This project adheres to [Semantic Versioning](https://semver.org/).

---

## [1.1.0] - 2025-01-28

🚀 **Major Feature Release - Phase 1 Roadmap**

### ✨ Added
- **Animation Support**: Marching ants effect with `animationOffset` parameter
  - Use with `AnimationController` to create moving dash patterns
  - Works with both traditional and custom patterns
  - Smooth animation with proper wrap-around handling

- **Advanced Dash Patterns**: Custom pattern arrays via `DashedPainter.pattern()`
  - Define patterns with arrays like `[5, 3, 2, 3]` for complex sequences
  - Supports unlimited pattern complexity
  - Automatic conversion from traditional step/span/points to arrays

- **Performance Optimization**: Path caching system
  - Automatic caching of computed path segments
  - Significant performance improvement for repeated patterns
  - `enableCaching` parameter to control caching behavior
  - `DashedPainter.clearCache()` and `DashedPainter.cacheSize` utilities

- **Enhanced DashedDecoration**:
  - `DashedDecoration.animated()` constructor for animated borders
  - `DashedDecoration.pattern()` constructor for custom patterns
  - Full backward compatibility with existing API

### 🎨 Enhanced
- Comprehensive example app with 4 demo screens:
  - Basic shapes demonstration
  - Animation effects showcase
  - Custom pattern gallery
  - Performance comparison tools
- Improved documentation with detailed usage examples
- Better code organization and maintainability

### 🔧 Technical
- Path computation refactored for better performance
- Animation system with proper offset calculations
- Caching system with automatic key generation
- Enhanced error handling and edge cases

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
