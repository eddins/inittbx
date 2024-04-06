# Initialize a MATLAB Toolbox

The function `inittbx` initializes a folder hierarchy and a basic set of files according to [*MATLAB Toolbox Best Practices*](https://github.com/mathworks/toolboxdesign) by [rpurser47](https://github.com/rpurser47) and others. The resulting hierarchy contains:

- `toolbox` folder with a sample function and a sample `gettingStarted.mlx`
- `toolbox/examples` folder with a sample example
- `tests` folder with a sample test
- Configuration files that enable `buildtool` to run code checks, run tests, and produce a release package
- `README.md` (stub)
- `LICENSE.md` (stub)
- `CHECKLIST.md` with a to-do list for getting your toolbox ready to publish

## Installation

Download the `inittbx.mltbx` file from the [GitHub repository releases area](https://github.com/eddins/inittbx/releases/) or from the [File Exchange](). Double-click on the downloaded file to automatically and run the MATLAB add-on installer. This will copy the files to your MATLAB add-ons area and add `inittbx` to your MATLAB search path.

Later, you can use the [MATLAB Add-On Manager](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) to uninstall.

## Getting Started

See the [Getting Started](./toolbox/gettingStarted.mlx) script for more information.

Copyright &copy; 2024 Steven L. Eddins