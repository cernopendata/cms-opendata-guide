# Photons

## Introduction

Photons are measured in the CMS experiment in the [electromagnetic calorimeter](https://cms.cern/detector/measuring-energy/energy-electrons-and-photons-ecal) and, in case they convert to electron-positron pairs, also in the [inner tracker](https://cms.cern/index.php/detector/identifying-tracks) as summarized on  introductory page on [Finding electrons and photons](https://cms.cern/news/finding-electrons-and-photons-cms-detector). The signals from these systems are processed with CMSSW through [subsequent steps](../../../cmssw/cmsswdatamodel.md) to form photon candidates which are then available in the photon collection of the data files.

## Photon 4-vector information

An example of an EDAnalyzer accessing photon information is available in the [PhotonAnalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/PhotonAnalyzer.cc) of the Physics Object Extractor Tool (POET). The following header files needed for accessing electron information are included:

``` cpp
//classes to extract Photon information
#include "DataFormats/EgammaCandidates/interface/Photon.h"
#include "DataFormats/EgammaCandidates/interface/PhotonFwd.h"
#include "DataFormats/GsfTrackReco/interface/GsfTrack.h"
#include "DataFormats/EgammaCandidates/interface/GsfElectron.h"
#include "RecoEgamma/EgammaTools/interface/ConversionTools.h"
#include "EgammaAnalysis/ElectronTools/interface/PFIsolationEstimator.h"
```

In [PhotonAnalyzer.cc](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/PhotonAnalyzer.cc), the photon four-vector elements are accessed as shown below.

``` cpp
Handle<reco::PhotonCollection> myphotons;
iEvent.getByLabel(photonInput, myphotons);

[...]

for (reco::PhotonCollection::const_iterator itphoton=myphotons->begin(); itphoton!=myphotons->end(); ++itphoton){

  [...]

  photon_e.push_back(itphoton->energy());
  photon_pt.push_back(itphoton->pt());
  photon_px.push_back(itphoton->px());
  photon_py.push_back(itphoton->py());
  photon_pz.push_back(itphoton->pz());
  photon_eta.push_back(itphoton->eta());
  photon_phi.push_back(itphoton->phi());

  [...]
}
```

## Photon identification

As explained in the [Physics Object page](../objects#detector-information-for-identification), a mandatory task in the physics analysis is to identify photons, i.e. to separate “real” objects from “fakes”. A large fraction of the energy deposited in the detector by all proton-proton interactions arises from photons originating in the decay of neutral mesons, and these electromagnetic showers provide a substantial background to signal photons. The identification criteria depend on the type of analysis.

The standard identification and isolation algorithm results can be accessed from the [photon object class](https://cmsdoxygen.web.cern.ch/cmsdoxygen/CMSSW_5_3_30/doc/html/d5/d35/classreco_1_1Photon.html) and the recommended working points for 2012 are implemented in the example code [PhotonAnalyzer.cc](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/PhotonAnalyzer.cc).

Three levels of identification criteria are defined

``` cpp
bool isLoose = false, isMedium = false, isTight = false;
```

For photons in the electromagnetic calorimeter barrel area, they are determined as follows:

``` cpp
if ( itphoton->eta() <= 1.479 ){
  if ( ph_hOverEm<.05 && ph_sigIetaIeta<.012 && 
      corrPFCHIso<2.6 && corrPFNHIso<(3.5+.04*itphoton->pt()) && 
      corrPFPhIso<(1.3+.005*itphoton->pt()) && passelectronveto==true) {
    isLoose = true;

    if ( ph_sigIetaIeta<.011 && corrPFCHIso<1.5 
        && corrPFNHIso<(1.0+.04*itphoton->pt()) 
        && corrPFPhIso<(.7+.005*itphoton->pt())){
      isMedium = true;

      if ( corrPFCHIso<.7 && corrPFNHIso<(.4+.04*itphoton->pt()) 
          && corrPFPhIso<(.5+0.005*itphoton->pt()) ){
        isTight = true;
      }
    }
  }
}
```

where

- `ph_sigIetaIeta` describes the variance of the ECAL cluster in psuedorapidity ("ieta" is an integer index for this angle).
- `ph_hOverEm` describes the ratio of HCAL to ECAL energy deposits, which should be small for good quality photons.
- The electron veto `passelectronveto` is obtained from an algorithm that indicates if photons have been identified also as electrons.
- `corr...Iso` variables represent different isolation properties of the photon.

The isolation variables are defined with the `PFIsolationEstimator` class in the default cone size of 0.3 with

``` cpp
PFIsolationEstimator isolator;
isolator.initializePhotonIsolation(kTRUE);
isolator. setConeSize(0.3);
const reco::VertexRef vertex(vertices, 0);
const reco::Photon &thephoton = *itphoton;
isolator.fGetIsolation(&thephoton, pfCands.product(), vertex, vertices);
double corrPFCHIso = 
  std::max(isolator.getIsolationCharged() - rhoIso * aEff.CH_AEff, 0.)/itphoton->pt();
double corrPFNHIso = 
  std::max(isolator.getIsolationNeutral() - rhoIso * aEff.NH_AEff, 0.)/itphoton->pt();
double corrPFPhIso = 
  std::max(isolator.getIsolationPhoton() - rhoIso * aEff.Ph_AEff, 0.)/itphoton->pt();
```

In the endcap part of the electromagnetic calorimeter, the procedure is similar with different values.

!!! Note "To do"
    - The isolation snippet needs more explanation
