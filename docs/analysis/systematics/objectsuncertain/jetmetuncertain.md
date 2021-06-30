#  Jet Uncertainity
As you should have read in the [Jets Guide](https://github.com/npervan/cms-opendata-guide/blob/master/docs/analysis/selection/objects/jets.md), due to the fact that the CMS detector does not measure jet energies perfectly, corrections are implemented to account for these uncertainties. These two methods are Jet Energy Corrections (JEC) and Jet Energy Resolution (JER), both of which are thoroughly described [here](https://arxiv.org/pdf/1607.03663.pdf).
## Jet Energy Corrections (JEC)
---
The first set of jet corrections are the JEC, which use three layers of corrections ("L1L2L3") that account for differences caused by psuedorapidity and measured transeverse momentum based on differences found between data and MC simulations.  Due to the uncertainity in the corrections, JEC includes both up and down versions of its scale factor.  


**Implementing JEC in CMS Software**

JEC is used in [JetAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/JetAnalyzer.cc) and includes multiple steps in its implementation. 

First, we must declare these variables in EDAnalyzer. <!---Could elaborate on why we need these specific variables-->

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

Then in the JetAnaylzer function, five of these are defined by file paths from [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py), and `jecPayloadNames` is filled with the three correction level parameters before being used to create the factorized jet corrector parameters.

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
}
```
Immediately after, we make the actual `FactorizedJetCorrector` and `JetCorrectionUncertainity` objects, which are directely used to calculate the correction factor.
```
// Make the FactorizedJetCorrector and Uncertainty                                                                                              
  jec_ = boost::shared_ptr<FactorizedJetCorrector> ( new FactorizedJetCorrector(vPar) );
  jecUnc_ = boost::shared_ptr<JetCorrectionUncertainty>( new JetCorrectionUncertainty(jecUncName_) );
  ...
}
 ```
In the actual jet loop, after setting the various uncorrected values for the iterated jet, we calculate the correction and correction uncertainity values, called `corr`, `corrUp` and `corrDown`. More about how these are calculated can be found [here](https://arxiv.org/abs/1607.03663).
```
void
JetAnalyzer::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
 for (reco::PFJetCollection::const_iterator itjet=myjets->begin(); itjet!=myjets->end(); ++itjet){
        reco::Candidate::LorentzVector uncorrJet = itjet->p4();
        jec_->setJetEta( uncorrJet.eta() );
        jec_->setJetPt ( uncorrJet.pt() );
        jec_->setJetE  ( uncorrJet.energy() );
        jec_->setJetA  ( itjet->jetArea() );
        jec_->setRho   ( *(rhoHandle.product()) );
        jec_->setNPV   ( vertices->size() );
        double corr = jec_->getCorrection();
       
        double corrUp = 1.0;
        double corrDown = 1.0;
        jecUnc_->setJetEta( uncorrJet.eta() );
        jecUnc_->setJetPt( corr * uncorrJet.pt() );
        corrUp = corr * (1 + fabs(jecUnc_->getUncertainty(1)));
        jecUnc_->setJetEta( uncorrJet.eta() );
        jecUnc_->setJetPt( corr * uncorrJet.pt() );
        corrDown = corr * (1 - fabs(jecUnc_->getUncertainty(-1)));
...
}
```

How these corrections are applied will be shown later.

## Jet Energy Resolution (JER)
---

**Accesing JER in CMS Software**

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
!!! Warning
    This page is under construction
