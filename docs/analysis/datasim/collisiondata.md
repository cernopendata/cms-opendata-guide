# Collision Data

!!! Warning
    This page is under construction

The CMS collision data is organized in primary datasets (PD).
All CMS open data primary datasets can be found with [this search](http://opendata.cern.ch/search?page=1&size=20&type=Dataset&subtype=Collision&experiment=CMS).

The dataset name consists of three parts separated by "/", e.g.:

```/TauPlusX/Run2011A-12Oct2013-v1/AOD```

The first part indicates the primary dataset contents (```TauPlusX```), the second part is the data-taking era (```Run2011A```) and reprocessing (```12Oct2013```), and the last one indicates the data format (```AOD```).

## Dataset contents

The primary dataset definition is centered around physics objects (SingleMu, Jet, Tau etc).
Events triggered by High Level Triggers  (HLT) with a similar physics contents or use
are mostly directed in the same PD. [This guide](http://opendata.cern.ch/docs/cms-guide-trigger-system)
gives an overview of the CMS trigger system.
Besides requirements on the physics content, the organisation of the primary
datasets has to satisfy constraints related to the data processing and handling,
such as the average event rate approximately uniform across the
different PDs, and the event rate within a certain range.

Each CMS collision dataset comes with a brief description of the contents, and
the full listing of all possible HLT trigger streams included in the dataset.
The instructions how to find the exact definitions and parameters of the
HLT trigger definitions can be found in
[Guide to the CMS Trigger System](http://opendata.cern.ch/docs/cms-guide-trigger-system) under "*HLT Trigger Path definitions*".

Since a given event can pass more than one HLT path, it
can be included in more than one primary dataset.
There's an overall overlap between the PDs of around 25-35% during Run1 and
it must be taken into account when combining events from different datasets in an analysis.

## Data taking and reprocessing

One year of data taking is divided in several "eras" indicated as RunA, RunB, etc.
According to the CMS data policy, 50% of data is published after the embargo period,
completed with the full release within 10 years. For proton-proton data, currently available are

* Run2010A and Run2010B
* Run2011A and Run2011B
* Run2012A, Run2012B, Run2012C and Run2012D
* Run2015D

In addition, heavy-ion data from HIRun2010 and HIRun2011 are available.

The data are reprocessed several times, and it is the last complete reprocessing available at the time of the release which is made public.

## Data format

The data format in use for Run1 data is Analysis Object Data (AOD). Starting from Run2, a slimmer version of this format called MINIAOD is used.
A brief description of data formats can be found in the introductory
[About CMS](http://opendata.cern.ch/docs/about-cms) under "*Primary and simulated datasets*".

<!-- ## Else (FIXME)

To consider:

* mention json files for validated runs/LS -
* mention condition data and GT
* Integrated luminosity here or in a separate chapter? -->

## References

G. Franzoni: Dataset definition for CMS operations and physics analyses
[CR2014_311.pdf](https://cds.cern.ch/record/1976679/files/CR2014_311.pdf)
