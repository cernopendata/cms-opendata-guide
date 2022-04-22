# Cross section calculation

!!! Warning
    This page is under construction

Cross sections can be calculated for MC samples. The starting page is [GenXSecAnalyzer](https://twiki.cern.ch/twiki/bin/viewauth/CMS/HowToGenXSecAnalyzer). Note that this link is currently restricted to CMS collaborators.

To account for the different running conditions in Run 1 vs Run 2, click the appropriate tab below for Run 1 vs Run 2 data.

=== "Run 1 Data"

    * This page is under construction

=== "Run 2 Data"

    * To compute the cross-section using the GenXSecAnalyzer, you can use a docker container. You can find a list of Docker container images available for CMS open data in the [guide page for CMS open data containers](http://opendata.cern.ch/docs/cms-guide-docker). A tutorial on working with docker is at the [CMS open data containers](https://cms-opendata-workshop.github.io/workshop2022-lesson-docker/).
    * To calculate a cross-section, follow the directions in the section "Running the GenXSecAnalyzer on an existing MC sample" in [GenXSecAnalyzer](https://twiki.cern.ch/twiki/bin/viewauth/CMS/HowToGenXSecAnalyzer).
    * To analyze Run 2 data, first fetch a CMSSW image and start a container by `docker run --name my_od -P -p 5901:5901 -it cmsopendata/cmssw_7_6_7-slc6_amd64_gcc493 /bin/bash` Then, `cd CMSSW_7_6_7/src` and `cmsenv`
    * Additional Notes: if the curl command listed in the GenXSecAnalyzer does not work for you, you can try downloading the ana.py file using curl to your own local system, and then copying the file into your docker container.
    * For the command `cmsRun ana.py inputFiles="file:xxxx.root" maxEvents=-1`, note that you must use the syntax "file:" before your root file name. For example, if your root file is called ttbar.root, you would type `cmsRun ana.py inputFiles="file:ttbar.root" maxEvents=-1`
