# Electrons

## Introduction

Electrons are measured in the CMS experiment combining the information from the [inner tracker](https://cms.cern/index.php/detector/identifying-tracks) and the [electromagnetic calorimeter](https://cms.cern/detector/measuring-energy/energy-electrons-and-photons-ecal) as summarized on an introductory page on [Finding electrons and photons](https://cms.cern/news/finding-electrons-and-photons-cms-detector). The signals from these systems are processed with CMSSW through [subsequent steps](../../../cmssw/cmsswdatamodel.md) to form electron candidates which are then available in the electron collection of the data files.

## Electron 4-vector and track information

An example of an EDAnalyzer accessing electron information is available in the [ElectronAnalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/ElectronAnalyzer.cc) of the Physics Object Extractor Tool (POET). The following header files needed for accessing electron information are included:

``` cpp
//classes to extract electron information
#include "DataFormats/EgammaCandidates/interface/GsfElectron.h"
#include "DataFormats/EgammaCandidates/interface/GsfElectronFwd.h"
#include "DataFormats/GsfTrackReco/interface/GsfTrack.h"
#include "RecoEgamma/EgammaTools/interface/ConversionTools.h"
#include "DataFormats/VertexReco/interface/Vertex.h"
#include "DataFormats/VertexReco/interface/VertexFwd.h"
```

In [ElectronAnalyzer.cc](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/ElectronAnalyzer.cc), the electron four-vector elements are accessed as shown below.

``` cpp
Handle<reco::GsfElectronCollection> myelectrons;
iEvent.getByLabel(electronInput, myelectrons);

[...]

for (reco::GsfElectronCollection::const_iterator itElec=myelectrons->begin(); itElec!=myelectrons->end(); ++itElec){

  [...]

  electron_e.push_back(itElec->energy());
  electron_pt.push_back(itElec->pt());
  electron_px.push_back(itElec->px());
  electron_py.push_back(itElec->py());
  electron_pz.push_back(itElec->pz());
  electron_eta.push_back(itElec->eta());
  electron_phi.push_back(itElec->phi());

  [...]
}
```

Most charged physics objects are also connected to tracks from the CMS tracking detectors. The charge of the object can be queried directly:

``` cpp
  electron_ch.push_back(itElec->charge());
```

Information from tracks provides other kinematic quantities that are common to multiple types of objects. Often, the most pertinent information about an object to access from its associated track is its impact parameter with respect to the primary interaction vertex. The access to the vertex collection is gained through the `getByLabel` method and the first elemement of the vertex collection gives the best estimate of the interaction point ("primary vertex" - `pv`):

``` cpp
  iEvent.getByLabel(InputTag("offlinePrimaryVertices"), vertices);
  math::XYZPoint pv(vertices->begin()->position());
```

The access to the track is provided through

``` cpp
  auto trk = itElec->gsfTrack();
```

for each electron in the electron loop, and the impact parameter information is obtained with

``` cpp
  electron_dxy.push_back(trk->dxy(pv));
  electron_dz.push_back(trk->dz(pv));
  electron_dxyError.push_back(trk->d0Error());
  electron_dzError.push_back(trk->dzError());
```

## Electron identification

As explained in the [Physics Object page](../objects#detector-information-for-identification), a mandatory task in the physics analysis is to identify electrons, i.e. to separate “real” objects from “fakes”. The criteria depend on the type of analysis.

The selection is based on cuts on a small number of variables. Different thresholds are used for electrons found in the ECAL barrel and the ECAL endcap. Selection variables may be categorized in three groups:

- photon ID variables (shower shape, track cluster matching etc)
- isolation variables
- conversion rejection variables.

The standard identification and isolation algorithm results can be accessed from the [electron object class](https://cmsdoxygen.web.cern.ch/cmsdoxygen/CMSSW_5_3_30/doc/html/d0/d6d/classreco_1_1GsfElectron.html) and the recommended working points are documented in the the [public data page for electron for 2010 and 2011](https://twiki.cern.ch/twiki/bin/view/CMSPublic/EgammaPublicData). The values implemented in the example code [ElectronAnalyzer.cc](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/ElectronAnalyzer.cc) are those recommended for 2012.

Three levels of identification criteria are defined

``` cpp
bool isLoose = false, isMedium = false, isTight = false;
```

For electrons in the electromagnetic calorimeter barrel area, they are determined as follows:

``` cpp
if ( abs(itElec->eta()) <= 1.479 ) {   
  if ( abs(itElec->deltaEtaSuperClusterTrackAtVtx())<.007 && 
        abs(itElec->deltaPhiSuperClusterTrackAtVtx())<.15 && 
        itElec->sigmaIetaIeta()<.01 && itElec->hadronicOverEm()<.12 && 
        abs(trk->dxy(pv))<.02 && abs(trk->dz(pv))<.2 && 
        missing_hits<=1 && passelectronveto==true &&
        abs(1/itElec->ecalEnergy()-1/(itElec->ecalEnergy()/itElec->eSuperClusterOverP()))<.05 
        && el_pfIso<.15){
    
    isLoose = true;
    
    if ( abs(itElec->deltaEtaSuperClusterTrackAtVtx())<.004 && 
          abs(itElec->deltaPhiSuperClusterTrackAtVtx())<.06 && 
          abs(trk->dz(pv))<.1 ){
      isMedium = true;
      
      if (abs(itElec->deltaPhiSuperClusterTrackAtVtx())<.03 && 
          missing_hits<=0 && el_pfIso<.10 ){
        isTight = true;
      }
    }
  }
}
```

where

- `deltaEta...` and `deltaPhi...` indicate how the electron's trajectory varies between the track and the ECAL cluster,
with smaller variations preferred for the "tightest" quality levels.
- `sigmaIetaIeta` describes the variance of the ECAL cluster in psuedorapidity ("ieta" is an integer index for this angle).
- `hadronicOverEm` describes the ratio of HCAL to ECAL energy deposits, which should be small for good quality electrons.
- The impact parameters `dxy` and `dz` should also be small for good quality electrons produced in the initial collision.
- Missing hits are gaps in the trajectory through the inner tracker (shouldn't be any!)
- The conversion veto is an algorithm that rejects electrons coming from photon conversions in the tracker, which should instead be reconstructed as part of the photon.
- The criterion using `ecalEnergy` and `eSuperClusterOverP` compares the differences between the electron's energy and momentum measurements, which should be very similar to each other for good electrons.
- `el_pfIso` represents how much energy, relative to the electron's, within a cone around the electron comes from other particle-flow candidates. If this value is small the electron is likely "isolated" in the local region.

The isolation variable `el_pfIso`, based on a cone size of 0.3 around the electron, is defined with

``` cpp
if (itElec->passingPflowPreselection()) {
  double rho = 0;
  if(rhoHandle.isValid()) rho = *(rhoHandle.product());
  double Aeff = effectiveArea0p3cone(itElec->eta());
  auto iso03 = itElec->pfIsolationVariables();
  el_pfIso = (iso03.chargedHadronIso + std::max(0.0,iso03.neutralHadronIso + iso03.photonIso - rho*Aeff))/itElec->pt();
} 
```

In the endcap part of the electromagnetic calorimeter, the procedure is similar with different values.

!!! Note "To do"
    - The isolation snippet needs more explanation
    - Check if the PR fixing the problem with missing hits affects the identification code snippet.
