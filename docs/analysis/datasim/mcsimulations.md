#  Monte Carlo Simulations

!!! Warning
    This page is under construction


A set of simulated data (Monte Carlo - MC) corresponding to the collision data 
is made available. All directly available MC datasets can be found with 
[this search](http://opendata.cern.ch/search?page=1&size=20&type=Dataset&subtype=Simulated&experiment=CMS). 
Furthermore, large amount of MC, thought to be of less frequent use, is available on demand 
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
~~~~~~~~~~~~~~~~

The dataset naming reflects the contents of the dataset, and the actual generator parameters 
with which the dataset contents have been defined can be 
found as explained under "*Finding the generator parameters*" in the 
[CMS Monte Carlo production overview](http://opendata.cern.ch/docs/cms-mc-production-overview).


## Processing

[CMS Monte Carlo production overview](http://opendata.cern.ch/docs/cms-mc-production-overview)
briefly describes the steps in the MC production chain.

## Data format

The data format in use for Run1 MC data is Analysis Object Data (AODSIM). 
A brief description of data formats can be found in the 
introductory [About CMS](http://opendata.cern.ch/docs/about-cms) under "*Primary and simulated datasets*".
