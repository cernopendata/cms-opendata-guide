#  Jet Uncertainity
#Jet Corrections

Unsurprisingly, the CMS detector does not measure jet energies perfectly, nor do simulation and data agree perfectly! The measured energy of jet must be corrected so that it can be related to the true energy of its parent particle. These corrections account for several effects and are factorized so that each effect can be studied independently.

##Correction Levels
![Corr Levels](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/correctionFlow.PNG)

Particles from additional interactions in nearby bunch crossings of the LHC contribute energy in the calorimeters that must somehow be distinguished from the energy deposits of the main interaction. Extra energy in a jet's cone can make its measured momentum larger than the momentum of the parent particle. The first layer ("L1") of jet energy corrections accounts for pileup by subtracting the average transverse momentum contribution of the pileup interactions to the jet's cone area. This average pileup contribution varies by pseudorapidity and, of course, by the number of interactions in the event.

The second and third layers of corrections ("L2L3") correct the measured momentum to the true momentum as functions of momentum and pseudorapidity, bringing the reconstructed jet in line with the generated jet. These corrections are derived using momentum balancing and missing energy techniques in dijet and Z boson events. One well-measured object (ex: a jet near the center of the detector, a Z boson reconstructed from leptons) is balanced against a jet for which corrections are derived.

All of these corrections are applied to both data and simulation. Data events are then given "residual" corrections to bring data into line with the corrected simulation. A final set of flavor-based corrections are used in certain analyses that are especially sensitive to flavor effects. All of the corrections are described in [this paper](https://arxiv.org/pdf/1107.4277.pdf). The figure below shows the result of the L1+L2+L3 corrections on the jet response.

![Jet Correction Response](https://cms-opendata-workshop.github.io/workshop-lesson-jetmet/assets/img/responseFlow.PNG)

## Jet Energy Corrections (JEC)
---
**Implementing JEC in CMS Software**

##JEC From Text Files

There are several methods available for applying jet energy corrections to reconstructed jets. We have demonstrated a method to read in the corrections from text files and extract the corrections manually for each jet. In order to produce these text files, we have to run [jec_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/JEC/jec_cfg.py).

```
isData = False
#if len(sys.argv) > 1: isData = bool(eval(sys.argv[1]))
#print 'Writing JEC text files. isData = ',isData

# CMS process initialization
process = cms.Process('jecprocess')
process.load('Configuration.StandardSequences.Services_cff')
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')

# connect to global tag
if isData:
#    process.GlobalTag.connect = cms.string('sqlite_file:/cvmfs/cms-opendata-conddb.cern.ch/FT53_V21A_AN6_FULL.db')
    process.GlobalTag.globaltag = 'FT53_V21A_AN6::All'
else:
#    process.GlobalTag.connect = cms.string('sqlite_file:/cvmfs/cms-opendata-conddb.cern.ch/START53_V27.db')
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
$ cd JEC
$ cmsRun jec_cfg.py
$ #edit the file and flip isData
$ cmsRun jec_cfg.py
```
JEC begins in [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py), where we apply jet energy corrections and Type-1 MET corrections on PAT jets, which are a popular object format in CMS that stands for "Physics Analysis Toolkit". To do this we will load the global tag and databases directly in the configuration file and use the ‘addJetCollection’ process to create a collection of pat::jets.

*Note: An additional JEC Uncertainity text file is needed for the `PatJetAnalyzer`. We will go over uncertainity later.*

```
if doPat:
 ...
 # Set up the new jet collection
 process.ak5PFJets.doAreaFastjet = True
 addPfMET(process, 'PF')
 
 addJetCollection(process,cms.InputTag('ak5PFJets'),
 		 'AK5', 'PFCorr',
		 doJTA        = True,
		 doBTagging   = True,
		 jetCorrLabel = ('AK5PF', cms.vstring(jetcorrlabels)),
		 doType1MET   = True,
		 doL1Cleaning = True,
		 doL1Counters = False,
		 doJetID      = True,
		 jetIdLabel   = "ak5",
		 )
 process.myjets= cms.EDAnalyzer('PatJetAnalyzer',
				   InputCollection = cms.InputTag("selectedPatJetsAK5PFCorr"),
                                   isData = cms.bool(isData),
                                   jecUncName = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/'+JecString+'Uncertainty_AK5PF.txt'), 
                                   jerResName = cms.FileInPath('PhysObjectExtractorTool/PhysObjectExtractor/JEC/JetResolutionInputAK5PF.txt')         
                               )
 ...
```
Now we can go into [PatJetAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/PatJetAnalyzer.cc), where in the Jet loop in `analyzeJets`, the correction is automatically corrected for each jet. We then save a uncorrected version of the jet as `uncorrJet`.

```
for (std::vector<pat::Jet>::const_iterator itjet=myjets->begin(); itjet!=myjets->end(); ++itjet){
     pat::Jet uncorrJet = itjet->correctedJet(0);     
     ...
```
How these corrections are applied will be shown later.

<!--- JER -------------------------------------------------------------------------------------------------------------------------------------------------------->

## Jet Energy Resolution (JER)
---

**Accesing JER in CMS Software**

Back in [JetAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/JetAnalyzer.cc), we have two new variables to declare.

```
class JetAnalyzer : public edm::EDAnalyzer {
...
private:
std::string              jerResName_;
boost::shared_ptr<SimpleJetCorrector> jer_;
...
}
```

Similar to JEC, inside of `JetAnalyzer` we have to retrive the file paths to the jet resolution parameters as defined in [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py), then create the `SimpleJetCorrector` object, which will be used next.

```
JetAnalyzer::JetAnalyzer(const edm::ParameterSet& iConfig)
{
...
  jerResName_ = iConfig.getParameter<edm::FileInPath>("jerResName").fullPath(); // JER Resolutions
...  
  JetCorrectorParameters *jerPar = new JetCorrectorParameters(jerResName_);
  jer_ = boost::shared_ptr<SimpleJetCorrector>( new SimpleJetCorrector(*jerPar) );
...
}
```
Now in the Jet loop inside of `analyze`, we declare `ptscale`, which will be the eventual scale factor we multiply onto the jet momentum. As well, similar to JEC, we declare `ptscale_down` and `ptscale_up` to account for uncertainties in our calculation.  
```
void
JetAnalyzer::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
    for (reco::PFJetCollection::const_iterator itjet=myjets->begin(); itjet!=myjets->end(); ++itjet){
       reco::Candidate::LorentzVector uncorrJet = itjet->p4()
       ...
       float ptscale, ptscale_down, ptscale_up;
       ...
```
Next, using a flag defined in [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py), we check if were the jets are from data or from a simulation. If we are using data, we don't have to adjust the resolution, so `ptscale` and the others are set to `1`.
```
       if(isData) {
         ptscale = 1;
         ptscale_down = 1;
         ptscale_up = 1;
       } 
```

Otherwise, we have to perform a few calculations. The three values we need to evaluate `ptscale` are `factors`, which is retrieved from the `factorLookup` function (More information about this function is shown in the dropdown below), `res`, which is defined using the `SimpleJetCorrector` object defined previously, and `itjet->pt()`, the uncorrected momentum of the iterated jet.


<details><summary>factorLookup</summary>

```
std::vector<float>
JetAnalyzer::factorLookup(float eta) { //used in jet loop for JER factor value
  if(eta > 3.2) { //input is > 0
    return {1.056, .865, 1.247}; // {factor, factor_down, factor_up}
  }
  else if(eta > 2.8) {
    return {1.395, 1.332, 1.468};
  }
  else if(eta > 2.3) {
    return {1.254, 1.192, 1.316};
  }
  else if(eta > 1.7) {
    return {1.208, 1.162, 1.254};
  }
  else if(eta > 1.1) {
    return {1.121, 1.092, 1.15};
  }
  else if(eta > .5) {
    return {1.099, 1.071, 1.127};
  }
  else {
    return {1.079, 1.053, 1.105};
  }
}
```	
</details>


```
       else {
         std::vector<float> factors = factorLookup(fabs(itjet->eta())); // returns in order {factor, factor_down, factor_up}
         std::vector<float> feta;
         std::vector<float> PTNPU;
	 feta.push_back( fabs(itjet->eta()) );
         PTNPU.push_back( itjet->pt() );
         PTNPU.push_back( vertices->size() );

         float res = jer_->correction(feta, PTNPU);
         ...
```
Lastly, using a stochastic smearing method described in [this paper](https://arxiv.org/pdf/1607.03663.pdf), we evaluate the final JER scale factors we need.
```
         TRandom3 JERrand;

         JERrand.SetSeed(abs(static_cast<int>(itjet->phi()*1e4)));
         ptscale = max(0.0, JERrand.Gaus(itjet->pt(),sqrt(factors[0]*(factors[0]+2))*res*itjet->pt())/itjet->pt());

         JERrand.SetSeed(abs(static_cast<int>(itjet->phi()*1e4)));
         ptscale_down = max(0.0, JERrand.Gaus(itjet->pt(),sqrt(factors[1]*(factors[1]+2))*res*itjet->pt())/itjet->pt());

         JERrand.SetSeed(abs(static_cast<int>(itjet->phi()*1e4)));
         ptscale_up = max(0.0, JERrand.Gaus(itjet->pt(),sqrt(factors[2]*(factors[2]+2))*res*itjet->pt())/itjet->pt());
	 ...
       }
}
```
	
##Uncertainity
Once we have done all of that, we can finally enter into `JetAnalyzer.cc` and declare these variables in `EDAnalyzer`.

```
class JetAnalyzer : public edm::EDAnalyzer {
...
private:
 // ----------member data ---------------------------    
  // jec variables
  std::vector<std::string> jecPayloadNames_;
  std::string              jecL1_;
  std::string              jecL2_;
  std::string              jecL3_;
  std::string              jecRes_;
  std::string              jecUncName_;
  boost::shared_ptr<JetCorrectionUncertainty> jecUnc_;
  boost::shared_ptr<FactorizedJetCorrector> jec_;
...
}
```

Then in the `JetAnaylzer` function, five of these are filled with file paths from [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py) we got from the `jec_cfg.py`, and `jecPayloadNames` is filled with the three correction level parameters before being used to create the factorized jet corrector parameters.

```
JetAnalyzer::JetAnalyzer(const edm::ParameterSet& iConfig)
{
...
  jecL1_ = iConfig.getParameter<edm::FileInPath>("jecL1Name").fullPath(); // JEC level payloads                     
  jecL2_ = iConfig.getParameter<edm::FileInPath>("jecL2Name").fullPath(); // JEC level payloads                     
  jecL3_ = iConfig.getParameter<edm::FileInPath>("jecL3Name").fullPath(); // JEC level payloads                     
  jecRes_= iConfig.getParameter<edm::FileInPath>("jecResName").fullPath();
  jecUncName_ = iConfig.getParameter<edm::FileInPath>("jecUncName").fullPath(); // JEC uncertainties                        

  //Get the factorized jet corrector parameters.
  jecPayloadNames_.push_back(jecL1_);
  jecPayloadNames_.push_back(jecL2_);
  jecPayloadNames_.push_back(jecL3_);
  if( isData == true ) jecPayloadNames_.push_back(jecRes_);
  std::vector<JetCorrectorParameters> vPar;
  for ( std::vector<std::string>::const_iterator payloadBegin = jecPayloadNames_.begin(),
	  payloadEnd = jecPayloadNames_.end(), ipayload = payloadBegin; ipayload != payloadEnd; ++ipayload ) {
    JetCorrectorParameters pars(*ipayload);
    vPar.push_back(pars);
  }
...
```
	
## Applying the Corrections 
---
##Will be demonstrated using this code (comment, obv)
```
corr_jet_pt.push_back(ptscale*corr*uncorrJet.pt());
       corr_jet_ptUp.push_back(corrUp*uncorrJet.pt());
       corr_jet_ptDown.push_back(corrDown*uncorrJet.pt());
       corr_jet_ptSmearUp.push_back(ptscale_up*corrUp*uncorrJet.pt());
       corr_jet_ptSmearDown.push_back(ptscale_down*corrUp*uncorrJet.pt())
```
## Putting it all together <!---Inviting the reader to take a look at the code with JEC+JER all togehter-->
!!! Warning
    This page is under construction
