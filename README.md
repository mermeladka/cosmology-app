# cosmology-app
Semester Project at the AMAS group at PSI, working on the initial conditions initialization for the cosmology mini app.

# Cloning this repository
This repository depends on multiple packages from different repositories, namely 
https://github.com/IPPL-framework/ippl.git src/ippl
https://github.com/icl-utk-edu/heffte.git src/heffte
https://github.com/bcrazzolara/SimGadget.git src/ngenic

and these are added as submodules into this github repository to avoid having to locally re-do everything 
every time you just want to run the cosmology app. Therefore, to clone the repository:

git clone --recurse-submodules <your-repo-url>
