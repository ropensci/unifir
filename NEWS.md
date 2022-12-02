# unifir 0.2.3

* Bug fixes:
    * Fixed bug where spaces in path to Unity would cause `unity_version()` and 
      `create_project()` to fail.
    * Fixed `InstantiatePrefab` C# requirements to now include `UnityEditor`.
    * Fixed test for new sf and terra versions.
    * `associate_coordinates()` will now only reproject if both objects have
      coordinate reference systems.
* Documentation changes:
    * Added citation information.

# unifir 0.2.2

* Redocumented to keep the package on CRAN.
* Internal changes:
  * `action()` is now much more modular, outsourcing to a handful of new 
    internal functions

# unifir 0.2.1
This is intentionally a very small patch release, intended to fix three problems:

* Provides an appropriate citation via `citation("unifir")` and in the README
* Addresses a failing test on M1 macs
* Uses `match.arg()` in appropriate places

# unifir 0.2.0

* Improvements and bug fixes:
    * `find_unity()` now doesn't escape its Unity path (so the string returned 
      is the actual path to the Unity engine, not a quoted version). 
      Accordingly, `action()` now wraps `unity` in `shQuote()`. (#4)
    * `add_default_tree()` now imports its trees standing upright by default. 
      If you manually set `x_rotation` to 0, however, the trees will import as 
      sideways as ever. (#7)
    * Examples are now tested (and work) (#8 1d5b1f3)
    * `create_terrain()` handles non-local terrain files (#6)
    * `unifir_prop()` now checks to make sure `script` exists and is a 
      `unifir_script`. Previously this errored with a baffling message about
      long vectors.
* Documentation changes:
    * Vignettes have been fleshed out, and a full example added to the 
      user-facing vignette. (#7)
    * Return values are better documented (#5)
    * Functions are consistently linked and documentation formatting is now
      more consistent (#5)
    * `find_unity()` doesn't now have a weird break in its documentation 
      sections
    * The README now links to vignettes and explains why anyone would want
      to deal with Unity in the first place

# unifir 0.1.0

* Added a `NEWS.md` file to track changes to the package.
