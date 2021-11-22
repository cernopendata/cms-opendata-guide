# ROOT

!!! Warning
    This page is under construction

From [ROOT's webpage](https://root.cern.ch)

*A modular scientific software toolkit.
It provides all the functionalities needed to deal with big data processing,
statistical analysis, visualisation and storage.
It is mainly written in C++ but integrated with other languages such as Python and R.*

It is the primary toolkit for many experimental analysis and while you are
free to analyze these datasets however you like, some familiarity with
ROOT will serve you well when accessing the data.

To get started analyzing data with ROOT and C++, start with [C++ and ROOT](https://cms-opendata-workshop.github.io/workshop2021-lesson-preexercise-cpp-and-root/).

To learn more about ROOT, see the [ROOT Manual](https://root.cern/manual/basics/).

* Many ROOT examples can be found [here](https://root.cern/tutorials/). If you don't know where to start, we would recommend
    * [fillrandom.C](https://root.cern/doc/master/fillrandom_8C.html) - fill in a 1D histogram from a parametric function
    * [basic.C](https://root.cern/doc/master/basic_8C.html) - read in data and create a root file
    * [h1ReadAndDraw.c](https://root.cern/doc/master/h1ReadAndDraw_8C.html) - read in a 1D histogram from a ROOT file, and then draw the histogram
    * [draw2dopt.C](https://root.cern/doc/master/draw2dopt_8C.html) - explore 2D drawing options

* Python has become the language of choice for many analysts and most of the examples
  you'll see make use of the PyROOT module, callable from python. For more on pyROOT, see [Python interface: PyROOT](https://root.cern/manual/python/). You can go through a number of examples [here](https://root.cern.ch/doc/master/group__tutorial__pyroot.html).
  If you don't know where to start, we would recommend
    * [hsimple.py](https://root.cern.ch/doc/master/hsimple_8py.html) - create and draw histograms
    * [fillrandom.py](https://root.cern.ch/doc/master/pyroot_2fillrandom_8py.html) - fill in a 1D histogram from a parametric function, and save your output as a root file
    * [fit1.py](https://root.cern.ch/doc/master/fit1_8py.html) - open the root file created from fillrandom.py, and do a fit
