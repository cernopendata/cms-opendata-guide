# Monte Carlo Simulations

A set of simulated data (Monte Carlo - MC) corresponding to the collision data
is made available. All directly available MC datasets can be found with
[this search](http://opendata.cern.ch/search?page=1&size=20&type=Dataset&subtype=Simulated&experiment=CMS).
For 2012 data taking, large amount of MC, thought to be of less frequent use, is available on demand
and included in [search results](http://opendata.cern.ch/search?page=1&size=20&type=Dataset&experiment=CMS&subtype=Simulated&ondemand=True)
if "*include on-demand datasets*" option is selected.

MC dataset are searchable by [categories](http://opendata.cern.ch/docs/simulated-dataset-categories),
which can be found under "Filter by category" on the left bar of the search page.

The dataset name consists of three parts separated by ```/``` e.g.:

```/DYToMuMu_M-15To50_Tune4C_8TeV-pythia8/Summer12_DR53X-PU_S10_START53_V19-v1/AODSIM```

The first part indicates the simulated physics process (```DYToMuMu```),
some of the production parameters (```M-15To50_Tune4C```), collision energy (```8TeV```),
 and the event generator used in the processing chain. [CMS simulated datasets names](http://opendata.cern.ch/docs/cms-simulated-dataset-names)
 gives more details in the naming.
 The second part is the production campaign (```Summer12_DR53X```), [pile-up](http://opendata.cern.ch/docs/cms-guide-pileup-simulation)
 profile (```PU_S10```) and processing [conditions](http://opendata.cern.ch/docs/cms-guide-for-condition-database) (```START53_V19```),
 and the last one indicates the data format (```AODSIM```).

## Dataset contents

The dataset naming reflects the contents of the dataset, and the actual generator parameters
with which the dataset contents have been defined can be
found as explained under "*Finding the generator parameters*" in the
[CMS Monte Carlo production overview](http://opendata.cern.ch/docs/cms-mc-production-overview).

## Processing

[CMS Monte Carlo production overview](http://opendata.cern.ch/docs/cms-mc-production-overview)
briefly describes the steps in the MC production chain.

## Data format

The data format in use for Run1 MC data is Analysis Object Data (AODSIM). Starting from Run2, a slimmer version of this format called MINIAODSIM is used.
A brief description of data formats can be found in the
introductory [About CMS](http://opendata.cern.ch/docs/about-cms) under "*Primary and simulated datasets*".

## Cross section calculation

Cross sections can be calculated for MC samples.

Caveat: The cross-sections found with this tool are those predicted by the respective generators. There may be better estimates, coming from dedicated task forces, theory papers etc.

To account for the different running conditions in Run 1 vs Run 2, click the appropriate tab below for Run 1 vs Run 2 data.

=== "Run 1 Data"

    * This page is under construction

=== "Run 2 Data"

    * First, fetch a CMSSW image and start a container. You can find a list of Docker container images available for CMS open data in the [guide page for CMS open data containers](http://opendata.cern.ch/docs/cms-guide-docker). A tutorial on working with docker is at [CMS open data containers](https://cms-opendata-workshop.github.io/workshop2022-lesson-docker/). After you start your container, you will need the file ana.py, which you can access by curl

    ``` bash
    curl https://raw.githubusercontent.com/cms-sw/genproductions/master/Utilities/calculateXSectionAndFilterEfficiency/genXsec_cfg.py -o ana.py
    ```

    * Next, you'll calculate a cross-section for a root file. You can identify the address of your root file by navigating to the CERN open data record. When you click the Download button at the bottom of the page, you'll get a printout of the path to your file. For example, a simulated dataset is available at [Simulated dataset TGJets_TuneCUETP8M1_13TeV_amcatnlo_madspin_pythia8 in MINIAODSIM format for 2015 collision data](http://opendata.cern.ch/record/19924). After clicking the Download button at the button of the page, you will be brought [here](http://opendata.cern.ch/record/19924/files/CMS_mc_RunIIFall15MiniAODv2_TGJets_TuneCUETP8M1_13TeV_amcatnlo_madspin_pythia8_MINIAODSIM_PU25nsData2015v1_76X_mcRun2_asymptotic_v12-v1_00000_file_index.txt), and you can copy the path of your file/files of interest to use to compute your cross-section.

    * To compute a cross-section using one of the above files, type

    ```bash
    cmsRun ana.py inputFiles="root://eospublic.cern.ch//eos/opendata/cms/mc/RunIIFall15MiniAODv2/TGJets_TuneCUETP8M1_13TeV_amcatnlo_madspin_pythia8/MINIAODSIM/PU25nsData2015v1_76X_mcRun2_asymptotic_v12-v1/00000/1A454199-F8B8-E511-A55D-7845C4FC374C.root" maxEvents=-1
    ```

    * Caveat: in the above method, you directly access the file from your container. If instead your files are on your local system and you plan to copy them to your container to use them, note that you must modify the syntax to: `cmsRun ana.py inputFiles="file:xxxx.root" maxEvents=-1` You must use the syntax "file:" before your root file name. For example, if your root file is called ttbar.root, you would type `cmsRun ana.py inputFiles="file:ttbar.root" maxEvents=-1`

    * After running the above commands, you will get a log file. As sample printout is: ![cross-section](https://github.com/jieunyoo/cms-opendata-guide/blob/master/docs/images/crossSectionLog.png)

    * A cross-section summary will be printed out. The definition of each quantity is:

        * Before matching: the cross section before jet matching and any filter
        * After matching: the cross section after jet matching BUT before any filter
        * Filter efficiency: the efficiency of the any filter.
        * After filter: the cross section after jet matching and additional filter are applied. This is your final cross section.
