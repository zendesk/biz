# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.8.2] (January 14, 2019)

### Added

- [#137](https://github.com/zendesk/biz/pull/137): Add support for Ruby 2.6

### Fixed

- [#139](https://github.com/zendesk/biz/pull/139): Treat endpoints consistently in calculations

## [v1.8.1] (October 30, 2018)

### Added

- [#131](https://github.com/zendesk/biz/pull/131): Add support for JRuby
- [#132](https://github.com/zendesk/biz/pull/132): Enrich the hours validation experience

## [v1.8.0] (September 14, 2018)

### Added

- [#109](https://github.com/zendesk/biz/pull/109): Implement shifts (date-based intervals) feature
- [#114](https://github.com/zendesk/biz/pull/114): Add support for Ruby 2.5

### Changed

- [#120](https://github.com/zendesk/biz/pull/120): Calibrate method privacy
- [#121](https://github.com/zendesk/biz/pull/121): Rename `Gemfile` to `gems.rb`

### Removed

- [#119](https://github.com/zendesk/biz/pull/119): Drop support for Ruby 2.2

## [v1.7.0] (June 13, 2017)

### Added

- [#105](https://github.com/zendesk/biz/pull/105): Add helper for generating periods on a date

### Removed

- [#100](https://github.com/zendesk/biz/pull/100): Drop support for Ruby 2.1

## [v1.6.1] (January 5, 2017)

### Added

- [#89](https://github.com/zendesk/biz/pull/89): Add support for Ruby 2.4

### Removed

- [#77](https://github.com/zendesk/biz/pull/77): Drop support for Ruby 2.0

## [v1.6.0] (June 13, 2016)

### Added

- [#67](https://github.com/zendesk/biz/pull/67): Implement breaks (time-segment holidays) feature
- [#71](https://github.com/zendesk/biz/pull/71): Include breaks when intersecting schedules
- [#72](https://github.com/zendesk/biz/pull/72): Add `on_break?` schedule method

### Fixed

- [#66](https://github.com/zendesk/biz/pull/66): Filter out empty intervals
- [#70](https://github.com/zendesk/biz/pull/70): Consider breaks in `in_hours?` calculation
- [#72](https://github.com/zendesk/biz/pull/72): Be consistent when excluding endpoints

## [v1.5.2] (April 12, 2016)

### Fixed

- [#60](https://github.com/zendesk/biz/pull/60): Reject negative scalars in for-duration calculations
- [#61](https://github.com/zendesk/biz/pull/61): Support zero scalar for-duration calculations

## [v1.5.1] (March 30, 2016)

### Changed

- [#53](https://github.com/zendesk/biz/pull/53): Allow configuration with array-like objects

## [v1.5.0] (March 29, 2016)

### Added

- [#51](https://github.com/zendesk/biz/pull/51): Add ability to intersect schedules

## [v1.4.0] (March 11, 2016)

### Changed

- [#46](https://github.com/zendesk/biz/pull/46): Standardize value object equality logic
- [#47](https://github.com/zendesk/biz/pull/47): Clean up remaining post-extraction clutter

## [v1.3.4] (February 13, 2016)

### Added

- [#41](https://github.com/zendesk/biz/pull/41): Add support for Ruby 2.3

### Removed

- [#44](https://github.com/zendesk/biz/pull/44): Remove unwarranted gem dependencies

## [v1.3.3] (October 19, 2015)

### Changed

- [#37](https://github.com/zendesk/biz/pull/37): Refactor "endnight" DST handling

## [v1.3.2] (October 17, 2015)

### Fixed

- [#36](https://github.com/zendesk/biz/pull/36): Add "endnight" DST handling

## [v1.3.1] (October 1, 2015)

### Fixed

- [#34](https://github.com/zendesk/biz/pull/34): Add basic hours validation

## [v1.3.0] (July 29, 2015)

### Added

- [#29](https://github.com/zendesk/biz/pull/29): Add `on_holiday?` schedule method

## [v1.2.2] (April 15, 2015)

### Fixed

- [#26](https://github.com/zendesk/biz/pull/26): Fix DST handling

## [v1.2.1] (March 23, 2015)

### Fixed

- [#22](https://github.com/zendesk/biz/pull/22): Allow second-level precision on day calculations

## [v1.2.0] (March 20, 2015)

### Added

- [#17](https://github.com/zendesk/biz/pull/17): Implement day-increment duration calculations

### Removed

- [#15](https://github.com/zendesk/biz/pull/15): Remove "day" as a unit of duration

## [v1.1.0] (February 26, 2015)

### Changed

- [#10](https://github.com/zendesk/biz/pull/10): Update license
- [#10](https://github.com/zendesk/biz/pull/10): Specify minimum support for Ruby 2.0
- [#11](https://github.com/zendesk/biz/pull/11): Tweak public method names

## v1.0.0 (February 17, 2015)

Initial public release.

[v1.8.2]: https://github.com/zendesk/biz/compare/v1.8.1...v1.8.2
[v1.8.1]: https://github.com/zendesk/biz/compare/v1.8.0...v1.8.1
[v1.8.0]: https://github.com/zendesk/biz/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/zendesk/biz/compare/v1.6.1...v1.7.0
[v1.6.1]: https://github.com/zendesk/biz/compare/v1.6.0...v1.6.1
[v1.6.0]: https://github.com/zendesk/biz/compare/v1.5.2...v1.6.0
[v1.5.2]: https://github.com/zendesk/biz/compare/v1.5.1...v1.5.2
[v1.5.1]: https://github.com/zendesk/biz/compare/v1.5.0...v1.5.1
[v1.5.0]: https://github.com/zendesk/biz/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/zendesk/biz/compare/v1.3.4...v1.4.0
[v1.3.4]: https://github.com/zendesk/biz/compare/v1.3.3...v1.3.4
[v1.3.3]: https://github.com/zendesk/biz/compare/v1.3.2...v1.3.3
[v1.3.2]: https://github.com/zendesk/biz/compare/v1.3.1...v1.3.2
[v1.3.1]: https://github.com/zendesk/biz/compare/v1.3.0...v1.3.1
[v1.3.0]: https://github.com/zendesk/biz/compare/v1.2.2...v1.3.0
[v1.2.2]: https://github.com/zendesk/biz/compare/v1.2.1...v1.2.2
[v1.2.1]: https://github.com/zendesk/biz/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/zendesk/biz/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/zendesk/biz/compare/v1.0.0...v1.1.0
