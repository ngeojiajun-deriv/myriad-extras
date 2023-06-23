# What is this
This repository contain the additional tools which make your life much easier especially when you are
very unsure the syntax of the file

# Tools
## `01_syntax.sh`
Usage: `01_syntax.sh <dir> ...`
Attempt to check syntax of all files under `<dir>/lib/`. Will use the provided docker file
or it will pick `deriv/myriad` when it is absent
## `02_no_xxx.sh`
Ensure no *.pm files contains the `XXX` imports
## `03_as_myriad_service_name.sh`
Usage: `03_as_myriad_service_name.sh <file>`
Try to guess the service name for the given `pm` file
## `04_service_deps.sh`
Usage: `04_service_deps.sh <file>`
Try to guess the dependencies for the services
## `99_new_service.sh`
Usage:  `99_new_service.sh <perl package name>`
Create a new service from the template