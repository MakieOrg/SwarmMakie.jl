# Changelog

## Unreleased

## 0.2.0 - 2025-11-12

- **Breaking**: Removed `gutter` and `gutter_threshold` attributes. The width of the jitter clouds is now controlled by `width` and options to handle points outside the margins will be added in the future.
- **Breaking**: Removed `SimpleBeeswarm` which caused overlaps, `SimpleBeeswarm2` was renamed to `SimpleBeeswarm`. Unexported and untested `MKBorregaardBeeswarm` and `SeabornBeeswarm` were removed.
- **Breaking**: The jitter algorithm structs don't take `jitter_width` and `clamped_portion` anymore and in general work differently than before. They now spread points to a width in data space that is determined by the distance between categories, similar to how `barplot` does it (so the width gets smaller when dodging is used, for example).