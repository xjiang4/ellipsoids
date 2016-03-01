# Installing software #

At first, you need to install _Sphinx_ according to [this instruction](http://sphinx-doc.org/latest/install.html). Sphinx goes as a package for _Python_, which installation is also described on a page above. Better install _Python_ version 2.7.`*`. The _Sphinx_ version used to create documentation was 1.2b2. You will also need _Sphinx_ package for numbering figures called _numfig_, which latest version can be downloaded [here](http://sourceforge.net/p/numfig/wiki/Home/). Untar downloaded tarball, open _Command Prompt_ and go to the directory with the `*`.py files from this tarball, then type: `python setup.py install`.
To get _PDF_ out from the _LaTeX_ sources, you need  the latest version of _MiKTeX_ to be installed (can be downloaded from [here](http://miktex.org/download)). Better choose to install packages on-the-fly when asked during the installation. When installation is finished, reboot the computer.

# Compilation #

To compile documentation, you need to open _Windows PowerShell_, go to the main directory of the project, which is \doc\ and:
  * to get _HTML_ version, run `.\make html`,
  * to get _LaTeX_ version, run `.\make latexpdf`. To get PDF, open Command Prompt, go to the \doc\`_`build\latex, type `pdflatex elltool_manual.tex` and then once again run this command to get references fixed.
During the compilation sometimes an exception occures connected with numfig. You just need to run `make` command once again.

Documentation structure is defined in main\_manual.rst, some of the additional features can be set in conf.py.