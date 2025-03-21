# packages-for-files-example

Example buildkite pipeline illustrating how buildkite packages can be used to store a file, and read the latest version between builds.

# Overview

* A pipeline can publish, and read the last version of a package.
* Uses OIDC to establish a trust between the pipeline and the package repository, see https://buildkite.com/docs/package-registries/security/oidc for more details.
* Uses the packages api to list and select the latest version of the package. see https://buildkite.com/docs/apis/rest-api/package-registries/registries for more details.
