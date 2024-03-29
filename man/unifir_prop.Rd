% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prop.R
\name{unifir_prop}
\alias{unifir_prop}
\title{The class for unifir prop objects}
\usage{
unifir_prop(prop_file, method_name, method_type, parameters, build, using)
}
\arguments{
\item{prop_file}{The system location for the C# template file}

\item{method_name}{The name of the method, in C# code}

\item{method_type}{The type of the method (usually matches its file name);
scripts can have multiple versions of the same method, each with different
method_name values, all sharing the same method_type.}

\item{parameters}{Method-specific parameters, typically used in the build
stage.}

\item{build}{A function that takes three arguments, \code{script}, \code{prop}, and
\code{debug}, and uses those to construct the C# method.}

\item{using}{A character vector of imports required for the method.}
}
\value{
An R6 object of class \code{unifir_prop}
}
\description{
This function is exported so that developers can add their own props
in new packages, without needing to re-implement the prop and script
classes themselves. It is not expected that end users will need this
function.
}
\details{
This function will check each argument for correctness. To be specific,
it performs the following checks:
\itemize{
\item \code{prop_file} must be either a \code{waiver} object (created by \link{waiver})
or a file path of length 1 pointing to a file that exists
\item \code{method_name} will be automatically generated if not existing. If
it exists, it must be a character vector of length 1
\item \code{method_type} must be a character vector of length 1
\item \code{build} must be a function with the arguments \code{script}, \code{prop},
and \code{debug} (in that order, with no other arguments). Any other
arguments needed by your build function should be passed as prop
parameters.
\item \code{using} must be a character vector (of any length, including 0)
}

If your prop needs data or arguments beyond these, store them as a
list in \code{parameters}, which is entirely unchecked.
}
\section{The debug argument}{

When \code{Sys.getenv(unifir_debugmode)} returns anything other than \code{""},
\link{action} runs in "debug mode". In addition to setting \code{exec} and \code{write}
to \code{FALSE} in \link{action}, this mode also attempts to disable any prop
functionality that would make changes to the user's disk -- no files
or directories should be altered. In this mode, \link{action} will pass
\code{debug = TRUE} as an argument to your prop; your prop should respect
the debug mode and avoid making any changes.
}

\examples{
unifir_prop(
  prop_file = waiver(), # Must be a file that exists or waiver()
  method_name = NULL, # Auto-generated if NULL or NA
  method_type = "ExampleProp", # Length-1 character vector
  parameters = list(), # Not validated, usually a list
  build = function(script, prop, debug) {},
  using = character(0)
)
}
