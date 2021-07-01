#  Jet Uncertainity
As you can read in the [Jets Guide](https://github.com/npervan/cms-opendata-guide/blob/master/docs/analysis/selection/objects/jets.md), due to the fact that the CMS detector does not measure jet energies perfectly, corrections are implemented to account for these uncertainties. These two methods are Jet Energy Corrections (JEC) and Jet Energy Resolution (JER), both of which are thoroughly described in the in the [2017 CMS jet algorithm paper](https://arxiv.org/pdf/1607.03663.pdf).
## Jet Energy Corrections (JEC)
---
The first set of jet corrections are the JEC, which use three layers of corrections ("L1L2L3") that account for differences caused by psuedorapidity and measured transeverse momentum based on differences found between data and MC simulations.  Due to the uncertainity in the corrections, JEC includes both up and down versions of its correction factor.  


**Implementing JEC in CMS Software**

JEC is used in [JetAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/JetAnalyzer.cc) and includes multiple steps in its implementation. 

First, we must declare these variables in `EDAnalyzer`. <!---Could elaborate on why we need these specific variables-->

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

Then in the `JetAnaylzer` function, five of these are defined by file paths from [poet_cfg.py](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/python/poet_cfg.py), and `jecPayloadNames` is filled with the three correction level parameters before being used to create the factorized jet corrector parameters.

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
Immediately after, we make the actual `FactorizedJetCorrector` and `JetCorrectionUncertainity` objects, which are directely used to calculate the correction factor.
```
// Make the FactorizedJetCorrector and Uncertainty                                                                                              
  jec_ = boost::shared_ptr<FactorizedJetCorrector> ( new FactorizedJetCorrector(vPar) );
  jecUnc_ = boost::shared_ptr<JetCorrectionUncertainty>( new JetCorrectionUncertainty(jecUncName_) );
  ...
} // end of JetAnalyzer
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

Back in [JetAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/JetAnalyzer.cc), we have two new variables to declare. *Note: To avoid confusion from the JEC example, `ak5PFCorrector` would be more appropriately named `jer_`, .*

```
class JetAnalyzer : public edm::EDAnalyzer {
...
private:
std::string              jerResName_;
boost::shared_ptr<SimpleJetCorrector> ak5PFCorrector;
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
  JetCorrectorParameters *ak5PFPar = new JetCorrectorParameters(jerResName_);
  ak5PFCorrector = boost::shared_ptr<SimpleJetCorrector>( new SimpleJetCorrector(*ak5PFPar) );
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

Otherwise, we have to perform a few calculations. The three values we need to evaluate `ptscale` are `factors`, which is retrieved from the `factorLookup()` function (shown in the dropdown below), `res`, which is defined using the `SimpleJetCorrector` object defined previously, and `itjet->pt()`, the uncorrected momentum of the iterated jet.
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

         float res = ak5PFCorrector->correction(feta, PTNPU);
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
