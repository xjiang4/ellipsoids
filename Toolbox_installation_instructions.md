# Prerequisites #

  * **Matlab 2012a 32-bit or higher**. Please note that a requirement to have 32-bit version comes from a need to be able to write the reliable tests that verify the calculation results with a certain precision. This precision depends on the architecture so that a test written for 32-bit Matlab may fail in 64-bit version and vice-versa. Also the following toolboxes are required:
    * **Matlab Parallel Computing Toolbox**. This toolbox will be used for running the test pack in parallel on different CPU cores which gives a significant boost on multi-core hardware.
    * **Optimization Toolbox**. This toolbox is used by MPT (see below) for solving the quadratic programming problems.
    * **Curve Fitting Toolbox**

  * **CVX 2.0 build 1010 or higher** from http://ellipsoids.googlecode.com/files/cvx_2_0_b1010_win32.zip
  * Install **MPT 3.0.12** from http://control.ee.ethz.ch/~mpt/3/ following the automatic installation instructions described at http://control.ee.ethz.ch/~mpt/3/Main/Installation

# How to install #

  * checkout the latest source from http://ellipsoids.googlecode.com/svn/trunk/ or download the latest package from http://code.google.com/p/ellipsoids/downloads/list

  * unzip CVX into **cvx** folder next to **products** folder(optional)
  * unzip MPT into **mpt** folder next to **products** folder(optional)
  * navigate to **install** subfolder
  * run `s_install` script
  * run `elltool.test.run_tests` to make sure that everything works

Please note that a developer needs to run `s_install` script every time Matlab is started. It's because the new files/folders that the developer can create during in the process of developing the toolbox should be added to Matlab path.
To automate the launch of `s_install` script it is suggested to create a separate Matlab shortcut for each source control working copy (see an example below). To do that you'll need to copy the standard Matlab shortcut and in the copied shortcut
  1. edit "Start in" field by typing in the path to "install" subfolder of your working copy
  1. edit "Target" field by adding the following string ` -r "s_install,cd .." -singleCompThread` where
    1. ` -r "s_install,cd .."` launches `s_install` script and goes one level up in the folder hierarchy
    1. `-singleCompThread` disables the multithreading, this is needed for the unit tests that check the precision of calculation as the latter can depend on the number of threads. Please note that this is only needed for the development. The ordinary users who just use the toolbox can skip this flag.
  1. (recommended) copy 'pathdef.m' file from `<MATLAB_ROOT>\toolbox\local` to `install` subfolder of the working copy (but **do not put `pathdef.m` under version control**). This makes Matlab use the copied `pathdef.m` for storing the path instead of using the one located in `<MATLAB_ROOT>\toolbox\local`. This is very useful when you use Matlab for more that one project/branch as paths for these projects/branches can be different. Thus by keeping the paths for the projectsin different copies of `pathdef.m` file you ensure that files from the different project are not put to Matlab path at the same time. By construction `s_install` script cleans the path entirely first and then adds the content of the working copy to the cleaned path. However there may not be such useful script in other projects or this script can be broken so putting `pathdef.m` into `install` subfolder is just a precausion.

![http://ellipsoids.googlecode.com/svn/wiki/images/matlab_shortcut_install.png](http://ellipsoids.googlecode.com/svn/wiki/images/matlab_shortcut_install.png)