# Cross section calculation

!!! Warning
    This page is under construction

Cross sections can be calculated for MC samples.

To account for the different running conditions in Run 1 vs Run 2, click the appropriate tab below for Run 1 vs Run 2 data.

=== "Run 1 Data"

    * This page is under construction

=== "Run 2 Data"

    * You can calculate a cross section using the GenXSecAnalyzer. To use it, you will need the file ana.py, which you can get by `curl https://raw.githubusercontent.com/cms-sw/genproductions/master/Utilities/calculateXSectionAndFilterEfficiency/genXsec_cfg.py -o ana.py `

    * Next, fetch a CMSSW image and start a container. You can find a list of Docker container images available for CMS open data in the [guide page for CMS open data containers](http://opendata.cern.ch/docs/cms-guide-docker). A tutorial on working with docker is at [CMS open data containers](https://cms-opendata-workshop.github.io/workshop2022-lesson-docker/). If you named your container `my_od`, you can fetch and start it by

    ``` bash

    docker start -i my_od

    cd CMSSW_7_6_7/src

    ```

    * Then, copy the file ana.py to your container. 
    
    ``` bash
    
    curl https://raw.githubusercontent.com/cms-sw/genproductions/master/Utilities/calculateXSectionAndFilterEfficiency/genXsec_cfg.py -o ana.py
    
    ```
    
    * To compute the cross-section, type `cmsRun ana.py inputFiles="file:xxxx.root" maxEvents=-1` in case you have copied one file locally or `cmsRun ana.py inputFiles="root://eospublic.cern.ch//eos/opendata/cms/mc/[....].root" maxEvents=-1` if you access the file through xrootd protocol from the CERN Open data portal. For example:
    
    ``` bash
    
    cmsRun ana.py inputFiles="root://eospublic.cern.ch//eos/opendata/cms/mc/RunIIFall15MiniAODv2/TGJets_TuneCUETP8M1_13TeV_amcatnlo_madspin_pythia8/MINIAODSIM/PU25nsData2015v1_76X_mcRun2_asymptotic_v12-v1/00000/1A454199-F8B8-E511-A55D-7845C4FC374C.root" maxEvents=-1
    
    ```

    * After running the above commands, you will get a log file.

    * A cross-section summary will be printed out. The definition of each quantity is:

        * Before matching: the cross section before jet matching and any filter
        * After matching: the cross section after jet matching BUT before any filter
        * Filter efficiency: the efficiency of the any filter.
        * After filter: the cross section after jet matching and additional filter are applied. This is your final cross section.

    * You can use any CMS Run2 Open Data MC sample for testing, the example above is from [Simulated dataset TGJets_TuneCUETP8M1_13TeV_amcatnlo_madspin_pythia8 in MINIAODSIM format for 2015 collision data](http://opendata.cern.ch/record/19924).
