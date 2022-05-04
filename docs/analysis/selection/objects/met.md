# MET

## What is MET?

[Missing transverse momentum](https://cds.cern.ch/record/1543527) is the negative vector sum of the transverse momenta of all particle flow candidates in an event. The magnitude of the missing transverse momentum vector is called missing transverse energy and referred to with the acronym “MET”. Since energy corrections are made to the particle flow jets, those corrections are propagated to MET by adding back the momentum vectors of the original jets and then subtracting the momentum vectors of the corrected jets. This correction is called “Type 1” and is standard for all CMS analyses. The jet energy corrections are discussed more deeply in the [Jets page](../jets#jet-corrections).

## Accessing MET in CMS Software

An example of an EDAnalyzer accessing MET information is available in the [MetAnalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/MetAnalyzer.cc) of the Physics Object Extractor Tool (POET). The following header files needed for accessing MET information are included:

``` cpp
//classes to extract PFMET information
#include "DataFormats/METReco/interface/PFMET.h"
#include "DataFormats/METReco/interface/PFMETFwd.h"
#include "DataFormats/PatCandidates/interface/MET.h"
```

In [MetAnalyzer.cc](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/MetAnalyzer.cc) we open the particle flow MET module (with `metInput` passed as `"pfMet"` in the [configuration file](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/python/poet_cfg.py)) and extract the magnitude and angle of the MET, the sum of all energy in the detector, and variables related to the “significance” of the MET. Note that MET quantities have a single value for the entire event, unlike the objects studied previously.

``` cpp
Handle<reco::PFMETCollection> mymets;
iEvent.getByLabel(metInput, mymets);

[...]

met_e = mymets->begin()->sumEt();
met_pt = mymets->begin()->pt();
met_px = mymets->begin()->px();
met_py = mymets->begin()->py();
met_phi = mymets->begin()->phi();
met_significance = mymets->begin()->significance();
```

The MET significance matrix could be accessed with:

``` cpp
auto cov = mymets->begin()->getSignificanceMatrix();
value_met_covxx = cov[0][0];
value_met_covxy = cov[0][1];
value_met_covyy = cov[1][1];
```

MET significance can be a useful tool: it describes the likelihood that the MET arose from noise or mismeasurement in the detector as opposed to a neutrino or similar non-interacting particle. The four-vectors of the other physics objects along with their uncertainties are required to compute the significance of the MET signature. MET that is directed nearly (anti)colinnear with a physics object is likely to arise from mismeasurement and should not have a large significance.

The difference between the Drell-Yan events with primarily fake MET and the top pair events with primarily genuine MET can be seen by drawing MET_pt or by drawing MET_significance. In both distributions the Drell-Yan events have smaller values than the top pair events.

!!! Warning
    This page is under construction
