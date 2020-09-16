# Physics Objects

!!! Warning
    This page is under construction

The CMS is a giant detector that acts like a camera that "photographs" particle collisions, allowing us to interpret their nature.

Certainly we cannot directly observe all the particles created in the collisions because some of them decay very quickly or simply do not interact with our detector.  However, we can infer their presence.  If they decay to other stable particles and interact with the apparatus, they leave signals in the CMS subdetectors. These signals are used to "reconstruct" the decay products; we call these "physics objects".  These objects could be electrons, muons, jets, etc., but also lower level objects like tracks.  For the current releases of open data, we store them in ROOT files following the EDM data model in AOD format.

In the CERN Open Portal site one can find a more detailed description of these physical objects and a list for [2010](http://opendata.cern.ch/docs/cms-physics-objects-2010) and [2011/2012](http://opendata.cern.ch/docs/cms-physics-objects-2011) releases.

As one can see in those guides, these physical objects are usually stored in specific *collections*.  For instance, [muons](http://opendata.cern.ch/docs/cms-physics-objects-2011#muons) are most commonly obtained from the `reco::Muon` collection.  For Run 1 data, [this page](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideDataFormatRecoMuon) gives a good description of the different collections.

When it comes to actually writing code to access these muons, however, one needs to know which CMSSW class matches a given collection of objects. In this particular example for muons, [this](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookMuonAnalysis#Available_information) page gives such information.  We immediately find out that the `reco::Muon` collection is associated with the CMSSW [DataFormats/MuonReco/interface/Muon.h](https://github.com/cms-sw/cmssw/blob/master/DataFormats/MuonReco/interface/Muon.h) class.

!!! Note "Remember"
    When accessing a specific piece of code in the CMSSW github repository, make sure you select the right git branch.  E.g., [CMSSW_5_3_X](https://github.com/cms-sw/cmssw/blob/CMSSW_5_3_X/DataFormats/MuonReco/interface/Muon.h) for 2011/2012 open data.

In addition to this base class, sometimes it is necessary to invoke other auxiliary classes.  For instance, `DataFormats/MuonReco/interface/MuonFwd.h`, which provides references to objects in a collection of Muon objects.

## References for CMS physics objects

In this list we point to different pages that can be used to explore the collections of reconstructed objects and its associated CMSSW classes.

### Electrons

### Photons

### Muons

### Jets

### Missing transverse energy (MET)

### Taus
