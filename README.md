# What is this
This repository contain the additional tools which make your life much easier especially when you are
very unsure the syntax of the file

# Tools
## `01_syntax.sh`
Usage: `01_syntax.sh <dir> ...`
Attempt to check syntax of all files under `<dir>/lib/`. Will use the provided docker file
or it will pick `deriv-enterprise/myriad` when it is absent

## `99_new_service.sh`
Usage:  `99_new_service.sh <perl package name>`
Create a new service from the template

