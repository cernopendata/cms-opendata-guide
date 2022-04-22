# Cross section calculation

!!! Warning
    This page is under construction

Cross sections can be calculated for MC samples.

To account for the different running conditions in Run 1 vs Run 2, click the appropriate tab below for Run 1 vs Run 2 data.

=== "Run 1 Data"

    * This page is under construction

=== "Run 2 Data"

    * You can calculate a cross section using the GenXSecAnalyzer. To use it, you will need the file ana.py, which you can get by `curl https://raw.githubusercontent.com/cms-sw/genproductions/master/Utilities/calculateXSectionAndFilterEfficiency/genXsec_cfg.py -o ana.py `

    * Next, fetch a CMSSW image and start a container. You can find a list of Docker container images available for CMS open data in the [guide page for CMS open data containers](http://opendata.cern.ch/docs/cms-guide-docker). A tutorial on working with docker is at [CMS open data containers](https://cms-opendata-workshop.github.io/workshop2022-lesson-docker/). If you named your container my_ord, you can fetch and start it by

    ``` bash

    docker run --name my_od -P -p 5901:5901 -it cmsopendata/cmssw_7_6_7-slc6_amd64_gcc493 /bin/bash

    cd CMSSW_7_6_7/src

    cmsenv

    ```

    * Then, copy the file ana.py to your container. You would also copy any root file/s you need to your container.

    * Finally, to compute the cross-section, type `cmsRun ana.py inputFiles="file:xxxx.root" maxEvents=-1` Note that you must use the syntax "file:" before your root file name. For example, if your root file is called ttbar.root, you would type `cmsRun ana.py inputFiles="file:ttbar.root" maxEvents=-1`

    * After running the above commands, you will get a log file.

    * A cross-section summary will be printed out. The definition of each quantity is:

        * Before matching: the cross section before jet matching and any filter
        * After matching: the cross section after jet matching BUT before any filter
        * Filter efficiency: the efficiency of the any filter.
        * After filter: the cross section after jet matching and additional filter are applied. This is your final cross section.

    * A file you can use for testing is 1A454199-F8B8-E511-A55D-7845C4FC374C.root from [Simulated dataset TGJets_TuneCUETP8M1_13TeV_amcatnlo_madspin_pythia8 in MINIAODSIM format for 2015 collision data](http://opendata.cern.ch/record/19924).
