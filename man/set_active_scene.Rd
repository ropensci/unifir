% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scene_management.R
\name{set_active_scene}
\alias{set_active_scene}
\title{Set a single scene to active.}
\usage{
set_active_scene(script, scene_name = NULL, method_name = NULL, exec = FALSE)
}
\arguments{
\item{script}{A \code{unifir_script} object, created by \link{make_script} or returned
by an \verb{add_prop_*} function.}

\item{scene_name}{The name of the scene to set as the active scene.}

\item{method_name}{The internal name to use for the C# method created. Will
be randomly generated if not set.}

\item{exec}{Logical: Should the C# method be included in the set executed by
MainFunc?}
}
\description{
Set a single scene to active.
}
\examples{
# First, create a script object.
# CRAN doesn't have Unity installed, so pass
# a waiver object to skip the Unity-lookup stage:
script <- make_script("example_script",
  unity = waiver()
)

# Now add props:
script <- set_active_scene(script, scene_name = "some_scene")

# Lastly, execute the script via the `action` function
}
\seealso{
Other props: 
\code{\link{add_default_player}()},
\code{\link{add_light}()},
\code{\link{add_prop}()},
\code{\link{add_texture}()},
\code{\link{create_terrain}()},
\code{\link{import_asset}()},
\code{\link{instantiate_prefab}()},
\code{\link{load_png}()},
\code{\link{load_scene}()},
\code{\link{new_scene}()},
\code{\link{read_raw}()},
\code{\link{save_scene}()},
\code{\link{validate_path}()}

Other utilities: 
\code{\link{add_default_player}()},
\code{\link{add_prop}()},
\code{\link{create_unity_project}()},
\code{\link{find_unity}()},
\code{\link{get_asset}()},
\code{\link{load_png}()},
\code{\link{load_scene}()},
\code{\link{new_scene}()},
\code{\link{read_raw}()},
\code{\link{save_scene}()},
\code{\link{validate_path}()},
\code{\link{waiver}()}
}
\concept{props}
\concept{utilities}
