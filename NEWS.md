# unifir (development version)

* `find_unity()` now doesn't escape its Unity path (so the string returned is
  the actual path to the Unity engine, not a quoted version). Accordingly,
  `action()` now wraps `unity` in `shQuote()`. (#4)

# unifir 0.1.0

* Added a `NEWS.md` file to track changes to the package.
