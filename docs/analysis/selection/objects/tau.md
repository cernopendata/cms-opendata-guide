## Tau leptons

The objects page (../../objects.md) shows you how to access muon collections in CMS, and which header files should be included in your C++ code in order to access all of their class information. The class information of tau leptons can similarly be accessed using the tau collections. 

We will be exploring another physics object, the tau object in this page.


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
vi src/TauAnalyzer.cc #(or your favorite text editor)
```

In the header of this code, the definitions of the tau classes are included:

~~~ c++
#include "DataFormats/TauReco/interface/PFTau.h"
#include "DataFormats/TauReco/interface/PFTauFwd.h"
#include "DataFormats/TauReco/interface/PFTauDiscriminator.h"
~~~ 


The TauAnalyzer tool is also an EDAnalyzer.
The "analyzeTaus" function of an EDAnalyzer is performed once per event. Taus can be accessed like this:

~~~ c++
void
TauAnalyzer::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
   using namespace edm;
   using namespace std;

   Handle<reco::PFTauCollection> mytaus;
   iEvent.getByLabel(tauInput, mytaus);
~~~ 

The result is called "taus" which is a collection of all the tau objects.
Collection classes are generally constructed as std::vectors. We can 
quickly access the number of tau per event and create a loop to access 
individual tau:

We can then access the tau four-vector elements and its charge as shown below. 
Here we only store taus that have transverse momenta that meet a threshold value.

~~~ c++
for (reco::PFTauCollection::const_iterator itTau=taus->begin(); itTau!=taus->end(); ++itTau){
  if (itTau->pt() > tau_min_pt) {
        tau_e.push_back(itTau->energy());
        tau_pt.push_back(itTau->pt());
        tau_px.push_back(itTau->px());
        tau_py.push_back(itTau->py());
        tau_pz.push_back(itTau->pz());
        tau_eta.push_back(itTau->eta());
        tau_phi.push_back(itTau->phi());
        tau_ch.push_back(itTau->charge());
     	tau_mass.push_back(itTau->mass());
}
~~~

The values for each tau are stored into a vector which will become a branch in a ROOT TTree.

![TauTTree](../../../../images/tauttree.png)

The CMS Tau object group relies almost entirely on pre-computed algorithms to determine the
quality of the tau reconstruction and the decay type. Since this object is not stable and has
several decay modes, different combinations of identification and isolation algorithms are
used across different analyses. The TWiki page provides a large table of available algorithms.

In contrast to the muon object, tau algorithm results are typically saved in the AOD files
as their own PFTauDisciminator collections, rather than as part of the tau object class.
They can be accessed like the other tau IDs which you can always find by referring to the 
output of `edmDumpEventContent` to find the exact form of the InputTag name. 

~~~ c++
// Get various tau discriminator collections
Handle<reco::PFTauDiscriminator> tausLooseIso, tausVLooseIso, tausMediumIso, tausTightIso,
                           tausDecayMode, tausLooseEleRej, tausMediumEleRej,
                           tausTightEleRej, tausLooseMuonRej, tausMediumMuonRej,
                           tausTightMuonRej, tausRawIso, tausLooseIsoMVA, tausMediumIsoMVA, tausTightIsoMVA,
                           tausLooseIso3Hits, tausMediumIso3Hits, tausTightIso3Hits;

iEvent.getByLabel(InputTag("hpsPFTauDiscriminationByDecayModeFinding"),
        tausDecayMode);

iEvent.getByLabel(InputTag("hpsPFTauDiscriminationByRawCombinedIsolationDBSumPtCorr"),
        tausRawIso);
iEvent.getByLabel(InputTag("hpsPFTauDiscriminationByVLooseCombinedIsolationDBSumPtCorr"),
        tausVLooseIso);
iEvent.getByLabel(InputTag("hpsPFTauDiscriminationByLooseCombinedIsolationDBSumPtCorr"),
        tausLooseIso);
iEvent.getByLabel(InputTag("hpsPFTauDiscriminationByMediumCombinedIsolationDBSumPtCorr"),
        tausMediumIso);
iEvent.getByLabel(InputTag("hpsPFTauDiscriminationByTightCombinedIsolationDBSumPtCorr"),
        tausTightIso);

//...etc...


~~~

The tau discriminator collections act as pairs, containing the index of the tau and the value
of the discriminant for that tau. Note that the vectors are filled by calls to the individual
discriminant objects, but referencing the vector index of the tau in the main tau collection.

~~~ c++
for (reco::PFTauCollection::const_iterator itTau=taus->begin(); itTau!=taus->end(); ++itTau){

    // Discriminators

    const auto idx = it - taus->begin();
    tau_iddecaymode.push_back(tausDecayMode->operator[](idx).second);
    tau_idisoraw.push_back(tausRawIso->operator[](idx).second);
    tau_idisovloose.push_back(tausVLooseIso->operator[](idx).second);       	

    // ...etc...
}
~~~

Also note that there are also the values for some discriminants that are based on rejecting electrons or muons.
The TWiki describes Loose/Medium/Tight ID levels for an "AntiElectron" algorithm and an "AntiMuon" algorithm. 

~~~ c++
tau_idantieleloose.push_back(tausLooseEleRej->operator[](idx).second);
tau_idantielemedium.push_back(tausMediumEleRej->operator[](idx).second);
tau_idantieletight.push_back(tausTightEleRej->operator[](idx).second);
tau_idantimuloose.push_back(tausLooseMuonRej->operator[](idx).second);
tau_idantimumedium.push_back(tausMediumMuonRej->operator[](idx).second);
tau_idantimutight.push_back(tausTightMuonRej->operator[](idx).second);
~~~

