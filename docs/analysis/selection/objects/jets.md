#  Jets


## What are jets?
---

Jets are spatially-grouped collections of long-lived particles that are produced when a quark or gluon hadronizes. The kinetmatic properties of jets resemble that of the initial partons that produced them. In the CMS language, jets are made up of many particles, with the following predictable energy composition:

- ~65% charged hadrons
- ~25% photons (from neutral pions)
- ~10% neutral hadrons

Jets are very messy! Hadronization and the subsequent decays of unstable hadrons can produce 100s of particles near each other in the CMS detector. Hence these particles are rarely analyzed individually. How can we determine which particle candidates should be included in each jet?



## Clustering
---

Jets can be clustered using a variety of different inputs from the CMS detector. "CaloJets" use only calorimeter energy deposits. "GenJets" use generated particles from a simulation. But by far the most common are "PFJets", from **particle flow candidates.**

The result of the CMS Particle Flow algorithm is a list of particle candidates that account for all inner-tracker and muon tracks and all above-threshold energy deposits in the calorimeters. These particles are formed into jets using a "clustering algorithm". The most common algorithm used by CMS is the "anti-kt" algorithm, which is abbreviated "AK". It iterates over particle pairs and finds the two (i and j) that are the closest in some distance measure and determines whether to combine them:

![cluster_eq](https://www.codecogs.com/eqnedit.php?latex=d_{ij}&space;=&space;min(p^{-2}_{T,i},p^{-2}_{T,j})\Delta&space;R^2_{ij}/R^2)

![cluster_im](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/clustering.png)

The momentum power (-2) used by the anti-kt algorithm means that higher-momentum particles are clustered first. This leads to jets with a round shape that tend to be centered on the hardest particle. In CMS software this clustering is implemented using the [fastjet](www.fastjet.fr) package.

![jet_depo](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/antikt.png)



## Pileup
Inevitably, the list of particle flow candidates contains particles that did not originate from the primary interaction point. CMS experiences multiple simultaneous collisions, called "pileup", during each "bunch crossing" of the LHC, so particles from multiple collisions coexist in the detector. There are various methods to remove their contributions from jets:

- Charged hadron subtraction [CHS](http://cms-results.web.cern.ch/cms-results/public-results/preliminary-results/JME-14-001/index.html): all charged hadron candidates are associated with a track. If the track is not associated with the primary vertex, that charged hadron can be removed from the list. CHS is limited to the region of the detector covered by the inner tracker. The pileup contribution to neutral hadrons has to be removed mathematically which will be discussed later.
- PileUp Per Particle Identification (PUPPI, available in Run 2): CHS is applied, and then all remaining particles are weighted based on their likelihood of arising from pileup. This method is more stable and performant in high pileup scenarios such as the upcoming HL-LHC era.



## Accessing Jets in CMS Software

Jets software classes have the same basic 4-vector methods as the objects discussed in the previous lesson:

```
Handle<PFJetCollection> myjets;
iEvent.getByLabel(InputTag("ak5PFJets"), myjets);

for (reco::PFJetCollection::const_iterator itjet=myjets->begin(); itjet!=myjets->end(); ++itjet){
jet_e.push_back(itjet->energy());
jet_pt.push_back(itjet->pt());
jet_eta.push_back(itjet->eta());
jet_phi.push_back(itjet->phi());	
jet_mass.push_back(itjet->mass());
}
```

##Jet ID

Particle-flow jets are not immune to noise in the detector, and jets used in analyses should be filtered to remove noise jets. CMS has defined a [Jet ID](http://cdsweb.cern.ch/record/1279362) with criteria for good jets:

>The PFlow jets are required to have charged hadron fraction CHF > 0.0 if within tracking fiducial region of |eta| < 2.4, neutral hadron fraction NHF < 1.0, charged electromagnetic (electron) fraction CEF < 1.0, and neutral electromagnetic (photon) fraction NEF < 1.0. These requirements remove fake jets arising from spurious energy depositions in a single sub-detector.

These criteria demonstrate how particle-flow jets combine information across subdetectors. Jets will typically have energy from electrons and photons, but those fractions of the total energy should be less than one. Similarly, jets should have some energy from charged hadrons if they overlap the inner tracker, and all the energy should not come from neutral hadrons. A mixture of energy sources is expected for genuine jets. All of these energy fractions (and more) can be accessed from the jet objects.


You can use the [cms-sw github repository](https://github.com/cms-sw/cmssw/tree/CMSSW_5_3_X/DataFormats/JetReco/) to see what methods are available for PFJets. We can implement a jet ID to reject jets that do not pass so that these jets are not stored in any of the tree branches. This code show an implementation of Jet ID cuts while also applying a minimum momentum threshold.
```
for (reco::PFJetCollection::const_iterator itjet=jets->begin(); itjet!=jets->end(); ++itjet){
if (itjet->pt > jet_min_pt && itjet->chargedHadronEnergyFraction() > 0 && itjet->neutralHadronEnergyFraction() < 1.0 &&
    itjet->electronEnergyFraction() < 1.0 && itjet->photonEnergyFraction() < 1.0){

    // jet calculations

```

##B Tagging Algorithms

Jet reconstruction and identification is an important part of the analyses at the LHC. A jet may contain the hadronization products of any quark or gluon, or possibly the decay products of more massive particles such as W or Higgs bosons. Several b tagging” algorithms exist to identify jets from the hadronization of b quarks, which have unique properties that distinguish them from light quark or gluon jets.

Tagging algorithms first connect the jets with good quality tracks that are either associated with one of the jet’s particle flow candidates or within a nearby cone. Both tracks and “secondary vertices” (track vertices from the decays of b hadrons) can be used in track-based, vertex-based, or “combined” tagging algorithms. The specific details depend upon the algorithm use. However, they all exploit properties of b hadrons such as:

-long lifetime,
-large mass,
-high track multiplicity,
-large semiloptonic branching fraction,
-hard fragmentation function.

Tagging algorithms are Algorithms that are used for b-tagging:

-Track Counting: identifies a b jet if it contains at least N tracks with significantly non-zero impact parameters.
-Jet Probability: combines information from all selected tracks in the jet and uses probability density functions to assign a probability to each track.
-Soft Muon and Soft Electron: identifies b jets by searching for a lepton from a semi-leptonic b decay.
-Simple Secondary Vertex: reconstructs the b decay vertex and calculates a discriminator using related kinematic variables.
-**Combined Secondary Vertex:** exploits all known kinematic variables of the jets, information about track impact parameter significance and the secondary vertices to distinguish b jets. This tagger became the default CMS algorithm.

These algorithms produce a single, real number (often the output of an MVA) called a b tagging “discriminator” for each jet. The more positive the discriminator value, the more likely it is that this jet contained b hadrons.


##Accessing Tagging Information
In JetAnalyzer.cc we access the information from the Combined Secondary Vertex (CSV) b tagging algorithm and associate discriminator values with the jets. The CSV values are stored in a separate collection in the AOD files called a JetTagCollection, which is effectively a vector of associations between jet references and float values (such as a b-tagging discriminator).

```
#include "DataFormats/JetReco/interface/PFJet.h"
#include "DataFormats/BTauReco/interface/JetTag.h"

Handle<PFJetCollection> myjets;
iEvent.getByLabel(InputTag("ak5PFJets"), myjets);
//define b-tag discriminators handle and get the discriminators
Handle<JetTagCollection> btags;
iEvent.getByLabel(InputTag("combinedSecondaryVertexBJetTags"), btags);

for (reco::PFJetCollection::const_iterator itjet=myjets->begin(); itjet!=myjets->end(); ++itjet){
    // from the btag collection get the float (second) from the association to this jet.
    jet_btag.push_back(btags->operator[](itjet - myjets->begin()).second);
}
```

You can use the command edmDumpEventContent to investiate other b tagging algorithms available as edm::AssociationVector types. This is an example opening the collections for two alternate taggers--the MVA version of CSV and the high purity track counting tagger, which was the most common tagger in 2011:

```
Handle<JetTagCollection> btagsMVA, btagsTC;
iEvent.getByLabel(InputTag("trackCountingHighPurBJetTags"), btagsTC);
iEvent.getByLabel(InputTag("combinedSecondaryVertexMVABJetTags"), btagsMVA);

// inside the jet loop
jet_btagmva.push_back(btagsMVA->operator[](it - myjets->begin()).second);
jet_btagtc.push_back(btagsTC->operator[](it - myjets->begin()).second);
```

The distributions in ttbar events (excluding events with values of -9 where the tagger was not evaluated) are shown below. The track counting discriminant is quite different and ranges 0-30 or so.

![tagger_dist](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/btagComp.png) 

##Working Points

A jet is considered "b tagged" if the discriminator value exceeds some threshold. Different thresholds will have different efficiencies for identifying true b quark jets and for mis-tagging light quark jets. As we saw for muons and other objects, a "loose" working point will allow the highest mis-tagging rate, while a "tight" working point will sacrifice some correct-tag efficiency to reduce mis-tagging. The [CSV algorithm has working points](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData) defined based on mis-tagging rate:

-Loose = ~10% mis-tagging = discriminator > 0.244
-Medium = ~1% mis-tagging = discriminator > 0.679
-Tight = ~0.1% mis-tagging = discriminator > 0.898

We can count the number  of "Medium CSV" b-tagged jets by summing up the number of jets with discriminant values greater than 0.679. After adding a variable declaration and branch we can sum up the counter:

```
value_jet_nCSVM = 0;
for (reco::PFJetCollection::const_iterator itjet=jets->begin(); itjet!=jets->end(); ++itjet){
    // skipping bits
    value_jet_btag[value_jet_n] = btags->operator[](it - jets->begin()).second
    if (value_jet_btag[value_jet_n] > 0.679) value_jet_nCSVM++;
}
```

We show distributions of the number CSV b jets at the medium working point in Drell-Yan events and top pair events. As expected there are significantly more b jets in the top pair sample.

![CSV_dist](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/btagCount.png)

##Data and Simulation Differences
When training a tagging algorithm, it is highly probable that the efficiencies for tagging different quark flavors as b jets will vary between simulation and data. These differences must be measured and corrected for using "scale factors" constructed from ratios of the efficiencies from different sources. The figures below show examples of the b and light quark efficiencies and scale factors as a function of jet momentum [read more](https://twiki.cern.ch/twiki/bin/view/CMSPublic/PhysicsResultsBTV13001). Corrections must be applied to make the b-tagging performance match between data and simulation. Read more about these corrections and their uncertainties [on this page](https://cms-opendata-guide/docs/analysis/systematics/objectsuncertain/btaguncertain.md). 

When training a tagging algorithm, it is highly probable that the efficiencies for tagging different quark flavors as b jets will vary between simulation and data. These differences must be measured and corrected for using "scale factors" constructed from ratios of the efficiencies from different sources. The figures below show examples of the b and light quark efficiencies and scale factors as a function of jet momentum [read more](https://twiki.cern.ch/twiki/bin/view/CMSPublic/PhysicsResultsBTV13001)

#Jet Corrections

Unsurprisingly, the CMS detector does not measure jet energies perfectly, nor do simulation and data agree perfectly! The measured energy of jet must be corrected so that it can be related to the true energy of its parent particle. These corrections account for several effects and are factorized so that each effect can be studied independently.

##Correction Levels
![Corr Levels](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/correctionFlow.PNG)

Particles from additional interactions in nearby bunch crossings of the LHC contribute energy in the calorimeters that must somehow be distinguished from the energy deposits of the main interaction. Extra energy in a jet's cone can make its measured momentum larger than the momentum of the parent particle. The first layer ("L1") of jet energy corrections accounts for pileup by subtracting the average transverse momentum contribution of the pileup interactions to the jet's cone area. This average pileup contribution varies by pseudorapidity and, of course, by the number of interactions in the event.

The second and third layers of corrections ("L2L3") correct the measured momentum to the true momentum as functions of momentum and pseudorapidity, bringing the reconstructed jet in line with the generated jet. These corrections are derived using momentum balancing and missing energy techniques in dijet and Z boson events. One well-measured object (ex: a jet near the center of the detector, a Z boson reconstructed from leptons) is balanced against a jet for which corrections are derived.

All of these corrections are applied to both data and simulation. Data events are then given "residual" corrections to bring data into line with the corrected simulation. A final set of flavor-based corrections are used in certain analyses that are especially sensitive to flavor effects. All of the corrections are described in [this paper](https://arxiv.org/pdf/1107.4277.pdf). The figure below shows the result of the L1+L2+L3 corrections on the jet response.

![Jet Correction Response](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/responseFlow.PNG)

##JEC From Text Files
There are several methods available for applying jet energy corrections to reconstructed jets. We have demonstrated a method to read in the corrections from text files and extract the corrections manually for each jet. The text files can be extracted from the global tag. First, set up sym links to the conditions databases for 2012 data and simulation ([reference instructions](http://opendata.cern.ch/docs/cms-guide-for-condition-database)):

```
$ ln -sf /cvmfs/cms-opendata-conddb.cern.ch/FT53_V21A_AN6_FULL FT53_V21A_AN6
$ ln -sf /cvmfs/cms-opendata-conddb.cern.ch/FT53_V21A_AN6_FULL.db FT53_V21A_AN6_FULL.db
$ ln -sf /cvmfs/cms-opendata-conddb.cern.ch/FT53_V21A_AN6_FULL FT53_V21A_AN6_FULL
$ ln -sf /cvmfs/cms-opendata-conddb.cern.ch/START53_V27 START53_V27
$ ln -sf /cvmfs/cms-opendata-conddb.cern.ch/START53_V27.db START53_V27.db
$ ls -l   ## make sure you see the full links as written above
```

We need to produce these text files before running the jet analyzer so the text files are available. So we use a small analyzer to open the database files we just linked:

```
isData = True
# connect to global tag                                                                                                               
if isData:
    process.GlobalTag.connect = cms.string('sqlite_file:/cvmfs/cms-opendata-conddb.cern.ch/FT53_V21A_AN6_FULL.db')
    process.GlobalTag.globaltag = 'FT53_V21A_AN6::All'
else:
    process.GlobalTag.connect = cms.string('sqlite_file:/cvmfs/cms-opendata-conddb.cern.ch/START53_V27.db')
    process.GlobalTag.globaltag = 'START53_V27::All'


# setup JetCorrectorDBReader                                                                                                          
process.maxEvents = cms.untracked.PSet(input=cms.untracked.int32(1))
process.source = cms.Source('EmptySource')
process.ak5 = cms.EDAnalyzer('JetCorrectorDBReader',
                             payloadName=cms.untracked.string('AK5PF'),
                             printScreen=cms.untracked.bool(False),
                             createTextFile=cms.untracked.bool(True))

if isData:
    process.ak5.globalTag = cms.untracked.string('FT53_V21A_AN6')
else:
    process.ak5.globalTag = cms.untracked.string('START53_V27')

process.p = cms.Path(process.ak5)
```

Note that this analyzer will need to be run with both `isData = True` and `isData = False` to produce text files for both.

```
$ cmsRun configs/jec_cfg.py
$ ## edit the file and flip isData
$ cmsRun configs/jec_cfg.py
```

In the [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py) we pass the names of the files to the analyzer:

```
JecString = 'START53_V27_'
if isData: JecString = 'FT53_V21A_AN6_'

process.myjets= cms.EDAnalyzer('JetAnalyzer',
		               InputCollection = cms.InputTag("ak5PFJets"),
                               isData = cms.bool(isData),
                               jecL1Name = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/'+JecString+'L1FastJet_AK5PF.txt'), 
                               jecL2Name = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/'+JecString+'L2Relative_AK5PF.txt'),     #Don't forget to run jec_cfg.py
                               jecL3Name = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/'+JecString+'L3Absolute_AK5PF.txt'),     #to get these .txt files :)
                               jecResName = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/'+JecString+'L2L3Residual_AK5PF.txt'),
                               jecUncName = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/'+JecString+'Uncertainty_AK5PF.txt'),
                               jerResName = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/JetResolutionInputAK5PF.txt')
```

In the analyzeJets function the correction is evaluated for each jet. The correction depends on the momentum, pseudorapidity, energy, and cone area of the jet, as well as the value of “rho” (the average momentum per area) and number of interactions in the event. The correction is used to scale the momentum of the jet.

```
for (reco::PFJetCollection::const_iterator itjet=myjets->begin(); itjet!=myjets->end(); ++itjet){
    reco::Candidate::LorentzVector uncorrJet = itjet->p4();
    jec_->setJetEta( uncorrJet.eta() );
    jec_->setJetPt ( uncorrJet.pt() );
    jec_->setJetE  ( uncorrJet.energy() );
    jec_->setJetA  ( itjet->jetArea() );
    jec_->setRho   ( *(rhoHandle.product()) );
    jec_->setNPV   ( vertices->size() );
    double corr = jec_->getCorrection();

    jet_pt.push_back(itjet->pt());
    corr_jet_pt.push_back(corr*uncorrJet.pt());
```

##Uncertainties
You will have noticed that nested among the jet energy correction code snippets give above were commands related to the uncertainty in this correction. The uncertainty is also read from a text file in this example, and is used to increase or decrease the correction to the jet momentum.

```
// Object definition
boost::shared_ptr<FactorizedJetCorrector> jec_;

// In the constructor the JetCorrectionUncertainty is set up
AOD2NanoAOD::AOD2NanoAOD(const edm::ParameterSet &iConfig){

  jecUncName_ = iConfig.getParameter<edm::FileInPath>("jecUncName").fullPath();      // JEC uncertainties                               
  jecUnc_ = boost::shared_ptr<JetCorrectionUncertainty>( new JetCorrectionUncertainty(jecUncName_) );

  // ....function continues
}

// In the analyzeJet function the uncertainty is evaluated
for (reco::PFJetCollection::const_iterator itjet=jets->begin(); itjet!=jets->end(); ++itjet){

    double corr = jec_->getCorrection();

    jecUnc_->setJetEta( uncorrJet.eta() );
    jecUnc_->setJetPt( corr * uncorrJet.pt() );
    corrUp = corr * (1 + fabs(jecUnc_->getUncertainty(1)));
    corrDown = corr * (1 - fabs(jecUnc_->getUncertainty(-1)));

    corr_jet_ptUp.push_back(corrUp*uncorrJet.pt());
    corr_jet_ptDown.push_back(corrDown*uncorrJet.pt());
}
```

The uncertainties have several sources, shown in the figure below. The L1 (pileup) uncertainty dominates at low momentum, while the L3 (absolute scale) uncertainty takes over for higher momentum jets. All corrections are quite precise for jets located near the center of the CMS barrel region, and the precision drops as pseudorapidity increases and different subdetectors lose coverage.

![JEC uncertainty](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/uncertainties.PNG)

!!! Warning
    This page is under construction

