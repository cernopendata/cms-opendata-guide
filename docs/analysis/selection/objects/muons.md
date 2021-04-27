#  Muons

## Description

The [objects page](../../objects.md) shows you how to access muon collections in CMS, and which header files should be included in your C++ code in order to access all of their class information.

CMS uses the phrase "physics objects" to speak broadly about particles that can be identified via
signals from the CMS detector. In this page, we will be exploring the muon object. The collection of reco::Muon objects or muons serves as the primary collection for accessing muon-related information in CMSSW. It contains the information on various types of muons:

*Standalone Muons:The segments reconstructed in the muon chambers of the detector are used to generate "seeds" consisting of position and direction vectors as well as information about the muon transverse momentum. The initial estimates are used as seeds for the track hits in the muon system. This results in reco::Track objects reconstructed in the muon spectrometer known as standalone muons. 
*Global Muons: For each standalone muon track, a search for tracks matching it among those reconstructed in the inner tracking system us performed and the best matching tracker track is selected. This results in reco::Track objects known as global muons.
*Tracker Muons: All tracker tracks are considered to be potential muon candidates and in checking this hypothesis by looking for compatible signatures in the calorimeters and in the muon system, tracker tracks are identified and are known as tracker muons.
*RPC Muons: A match is sought between the extrapolated inner track and hits on the RPC (resistive plate chambers) muon detectors.
*Calo Muons: A subset of all tracker tracks reconstructed in the event which includes tracks with energy deposition in the calorimeters compatible with those of a minimum-ionizing particle.

## Setup
The [PhysObjectExtractorTool](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool)
repository is the example we will use for accessing information from AOD files.

```
cd ~/CMSSW_5_3_32/src/
cmsenv
git clone git://github.com/cms-legacydata-analyses/PhysObjectExtractorTool.git 
cd PhysObjectExtractorTool
cd PhysObjectExtractor
scram b
vi src/MuonAnalyzer.cc #(or your favorite text editor)
```

In the header of this code, the definitions of the muon classes are included:

~~~ c++
#include "DataFormats/MuonReco/interface/Muon.h"
#include "DataFormats/MuonReco/interface/MuonFwd.h"
#include "DataFormats/MuonReco/interface/MuonSelectors.h"
~~~ 


A full description of the reco::Muon class can be found in Muon.h. The MuonAnalyzer tool is an EDAnalyzer.
The "analyzeMuons" function of an EDAnalyzer is performed once per event. Muons can be accessed like this:

~~~ c++
void
MuonAnalyzer::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
   using namespace edm;
   using namespace std;

   Handle<reco::MuonCollection> mymuons;
   iEvent.getByLabel(muonInput, mymuons); //where the input tag is declared in the EDAnalyzer
~~~ 

The result is called "muons" which is a collection of all the muon objects.
Collection classes are generally constructed as std::vectors. We can 
quickly access the number of muons per event and create a loop to access 
individual muons:

We can then access the muon four-vector elements and its charge as shown below. 
Here we only store muons that have transverse momentums that meet a threshold value.
~~~ c++
for (reco::MuonCollection::const_iterator itmuon=muons->begin(); itmuon!=muons->end(); ++itmuon){
          if (itmuon->pt() > mu_min_pt) {
         
        	    muon_e.push_back(itmuon->energy());
        	    muon_pt.push_back(itmuon->pt());
        	    muon_px.push_back(itmuon->px());
        	    muon_py.push_back(itmuon->py());
        	    muon_pz.push_back(itmuon->pz());
        	    muon_eta.push_back(itmuon->eta());
        	    muon_phi.push_back(itmuon->phi());
        	    muon_ch.push_back(itmuon->charge());
        	    muon_mass.push_back(itmuon->mass());
         }           
 

}
~~~

The values for each muon are stored into a vector which will become a branch in a ROOT TTree.

![MuonTTree](../../../../images/muonttree.png)

## Muon corrections

The CMS Muon object group has created member functions for the identification algorithms that simply
storing pass/fail decisions about the quality of each muon. As shown below, the algorithm depends
on which vertex is being considered as the primary interaction vertex!

Hard processes produce large angles between the final state partons. The final object of interest will be separated from 
the other objects in the event or be "isolated". For instance, an isolated muon might be produced in the decay of a W boson.
In contrast, a non-isolated muon can come from a weak decay inside a jet. 

Muon isolation is calculated from a combination of factors: energy from charged hadrons, energy from
neutral hadrons, and energy from photons, all in a cone of radius $\Delta R < 0.3$ or 0.4 around
the muon. Many algorithms also feature a "correction factor" that subtracts average energy expected
from pileup contributions to this cone. Decisions are made by comparing this energy sum to the
transverse momentum of the muon. 

~~~ c++
for (reco::MuonCollection::const_iterator itmuon=muons->begin(); itmuon!=muons->end(); ++itmuon){

    // If this muon has isolation quantities...
    if (itmuon->isPFMuon() && itmuon->isPFIsolationValid() {

       // get the isolation info in a certain cone size:
       auto iso04 = itmuon->pfIsolationR04();

       // and calculate the energy relative to the muon's transverse momentum
       muon_pfreliso04all.push_back((iso04.sumChargedHadronPt + iso04.sumNeutralHadronEt + iso04.sumPhotonEt)/itmuon->pt());
    }

    // Store the pass/fail decisions about Tight ID
    muon_tightid.push_back(muon::isTightMuon(*itmuon, *vertices->begin()));
}

~~~

## Alternate IDs and isolations

Using the documentation on the TWiki page, we can adjust the 0.4-cone muon isolation calculation
to apply the "DeltaBeta" pileup correction and then add the pass/fail information about the Loose 
and Soft identification working points.

The DeltaBeta correction for pileup involves subtracting off half of the pileup contribution
that can be accessed from the "iso04" object already being used:

~~~ c++
mu_pfreliso04all.push_back((iso04.sumChargedHadronPt + max(0.,iso04.sumNeutralHadronEt + iso04.sumPhotonEt- 0.5*iso04.sumPUPt))/itmuon->pt());
~~~

~~~ c++
muon_tightid.push_back(muon::isTightMuon(*itmuon, *vertices->begin()));
muon_softid.push_back(muon::isSoftMuon(*itmuon, *vertices->begin()));
~~~


!!! Warning
    This page is under construction

## Installation

Detailed instructions on how to install the CERN virtual machines can be found in the [2010](http://opendata.cern.ch/docs/cms-virtual-machine-2010) and [2011/2012](http://opendata.cern.ch/docs/cms-virtual-machine-2011) virtual machine installation guides from the CERN Open Portal.  Choose the one to follow depending on the data release you will be working on.

In summary, the basic steps are as follows:

- Download and install the latest (or even better, the latest tested) version of [VirtualBox](https://www.virtualbox.org/wiki/Downloads).  Note that it is available for an ample range of platforms.
- Download the **latest** CMS virtual image file.  Choose between [2010](http://opendata.cern.ch/docs/cms-virtual-machine-2010#downloading-and-creating-a-virtual-machine) or [2011/2012](http://opendata.cern.ch/docs/cms-virtual-machine-2011#downloading-and-creating-a-virtual-machine), depending on the data release of interest. Once downloaded, import the image file into VirtualBox.

    !!! Note "Remember"
        Always use the latest image file available for [2010](http://opendata.cern.ch/record/250) or [2011/2012](http://opendata.cern.ch/record/252). Older ones are usually deprecated.
