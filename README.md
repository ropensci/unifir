
<!-- README.md is generated from README.Rmd. Please edit that file -->

# unifir: A Unifying API for Working with Unity in R <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/license-MIT-green)](https://choosealicense.com/licenses/mit/)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/unifir)](https://CRAN.R-project.org/package=unifir)
[![R-CMD-check](https://github.com/mikemahoney218/unifir/workflows/R-CMD-check/badge.svg)](https://github.com/mikemahoney218/unifir/actions)
[![Codecov test
coverage](https://codecov.io/gh/mikemahoney218/unifir/branch/main/graph/badge.svg)](https://app.codecov.io/gh/mikemahoney218/unifir?branch=main)
<!-- badges: end -->

unifir is a unifying API for creating and managing Unity scenes directly
from R (without requiring GUI interaction). Users are able to write
natural-feeling R code to create “scripts” (C# programs) composed of
“props” (C# methods) which produce scenes inside the Unity engine.

In its current state, unifir is unstable, untested, and somewhat
unreliable. We’re working on it.

## Installation

You can install the development version of `unifir` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mikemahoney218/unifir")
```

## Example

The simplest unifir programs will create new Unity projects, load and
save scenes, and manage the state of a Unity project. For instance, to
create a new project, create a new scene in that project with the
standard light and camera, and save the scene, we’d use the following:

``` r
library(unifir)

make_script("example_unifir_script") |> 
  new_scene("DefaultGameObjects", "Single") |> 
  save_scene("example_unifir_scene") |> 
  action()
```

This package also integrates with other R packages to create terrain
surfaces and game objects within scenes. This API is still unstable and
mostly undocumented.

## Code of Conduct

Please note that the unifir project is released with a [Contributor Code
of
Conduct](https://mikemahoney218.github.io/unifir/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Disclaimer

These materials are not sponsored by or affiliated with Unity
Technologies or its affiliates. “Unity” is a trademark or registered
trademark of Unity Technologies or its affiliates in the U.S. and
elsewhere.
