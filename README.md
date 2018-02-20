# geomorph
Geomorph is a software package for performing all stages of geometric morphometric shape analysis of 2- and 3-dimensional landmark points, as well as semilandmarks on curves and surfaces, in the R statistical computing environment. This repository is dedicated to providing beta versions between CRAN uploads.

### To install the current geomorph R-package from CRAN:

<i> Within R:</i>

<code> install.packages("geomorph") </code>

For Mac users:  please also install XQuartz from <https://www.xquartz.org/>. This allows the library(rgl) to function.

### To install the current version of geomorph R-package from Github using devtools:

<i> Within R:</i>

<code> install.packages("devtools")</code>

<code> devtools::install_github("geomorphR/geomorph",ref = "Stable")</code>

This installs a stable release of the current version of geomorph on CRAN, allowing us to quickly fix errors that slip thorugh the cracks and are uploaded with the CRAN version.

### To install the Development version (beta) of geomorph R-package from Github using devtools:

<i> Within R:</i>

<code> install.packages("devtools")</code>

<code> devtools::install_github("geomorphR/geomorph",ref = "Develop")</code>

## NOTE FOR THE PRE-RELEASE (BETA) VERSION: We strongly discourage you from publishing results with this version, unless you check with the authors first.
