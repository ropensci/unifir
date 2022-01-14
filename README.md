
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

unifir is a unifying API for creating and managing
[Unity](https://unity.com/) scenes directly from R (without requiring
GUI interaction). Users are able to write natural-feeling R code to
create “scripts” (C# programs) composed of “props” (C# methods) which
produce scenes inside the Unity engine. While it is entirely possible to
create fleshed-out Unity scenes through this package, unifir is
primarily designed around being easy to wrap in other packages, so that
any number of packages interacting with Unity can all share a common
framework.

The first function most unifir workflows will call is `make_script`,
which creates a “script” object. In that script, we can tell unifir
things like where we want to save our project:

``` r
library(unifir)
script <- make_script(project = "path/to/project")
```

We can then iteratively add props to our project, building up a series
of commands that we’ll execute in sequence to create a Unity scene:

``` r
script <- add_default_player(script, x_position = 10)
script <- add_light(script)
script <- save_scene(script)
```

All of these functions are designed with the pipe in mind, letting you
easily simplify your code:

``` r
script <- make_script(project = "path/to/project") |> 
  add_default_player(x_position = 10) |> 
  add_light() |> 
  save_scene()
```

Once all your props are set, it’s time to execute the script via the
`action` function! This function will create a new Unity project (if
necessary), write your “script” object to a C# file, and execute it
inside the Unity project.

``` r
action(script)
```

Open your new project from UnityHub, open the scene you created with
`save_scene`, and you’ll see the outputs from your script right in front
of you!

Right now, unifir wraps the elements of the Unity API that I’ve found
useful in my own work, principally focused around creating GameObjects,
lights, player controllers, and terrain surfaces. If you are interested
in pieces of the API that haven’t made it into unifir yet, please open
an issue or a PR!

## Installation

The easiest way to install unifir is to install it directly from
R-Universe:

``` r
# Enable universe(s) by mikemahoney218
options(repos = c(
  mikemahoney218 = 'https://mikemahoney218.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))

# Install unifir
install.packages('unifir')
```

You can also install unifir from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("mikemahoney218/unifir")
```

Note that right now there is no release version of unifir; all published
versions are considered “development” versions. While the unifir API is
solidifying, it is not yet solid, and breaking changes may happen at any
time.

While unifir can be used by itself, you’ll probably want to [install
Unity](https://unity.com/download) in order to actually make Unity
projects.

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
