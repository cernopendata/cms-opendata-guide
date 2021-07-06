# B Tag Uncertainty


### ![Scale Factors](https://twiki.cern.ch/twiki/pub/CMSPublic/PhysicsResultsBTV13001/mistag_csvm.pdf)

In simulation, the efficiency for tagging b quarks as b jets is defined as the number of "real b jets" (jets spatially matched to generator-level b hadrons) tagged as b jets divided by the number of real b jets. The efficiency for mis-tagging c or light quarks as b jets is similar (real c/light jets tagged as b jets / real c/light jets). These values are typically computed as functions of the momentum or pseudorapidity of the jet. The "real" flavor of the jet is accessed most simply by creating pat::Jet objects instead of reco::Jet objects.

Scale factors to increase or decrease the number of b-tagged jets in simulation can be applied in a number of ways, but typically involve weighting simulation events based on the efficiencies and scale factors relevant to each jet in the event. Scale factors for the CSV algorithm are available for Open Data and involve extracting functions from a comma-separated-values file. Details and usage reference can be found here:

-[Explanation](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Data_MC_Scale_Factors)
-[Data file for the CSV algorithm](https://twiki.cern.ch/twiki/pub/CMSPublic/BtagRecommendation2011OpenData/CSV.csv)
-[Examples of application methods](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Methods_to_Apply_b_Tagging_Effic)

### Data file for the CSV algorithm
[This file](https://twiki.cern.ch/twiki/pub/CMSPublic/BtagRecommendation2011OpenData/CSV.csv) contains a lot of useful information for calculating scale factors. When looking at the file itself however, some of the column headers are titled oddly or do not give helpful information on how to navigate the column. Some important titles to giver more context to are as follows: 
###### OperatingPoint - This is the light (0), medium (1), or tight (2) cut of the light flavored jet.
###### formula - This is the equation for calculating the scale factor, where x is the momentum (pt) of the jet.
###### jetFlavor - b = 0, c = 1, udsg = 2.
Sorting Columns and creating filters with the .csv file can make accessing and finding sepcific scale factor equations. For example, filtering the OperatingPoint column to only show "1" will give you only medium cut jet information.

## Calculating Efficiencies 
In POET, there is a branch labeled "BTagging" that is a branch that is dedicated to calculating efficiencies. The file, [WeightAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/src/WeightAnalyzerBEff.cc), takes care of a lot of the calculating piece for you in its "for loop", but there are some important areas within that code to go over. 
#### Bin Size
In [WeightAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/src/WeightAnalyzerBEff.cc), there is a spot to input custom bins that looks like this:
```
double ptbinsB[10] = {0, 15, 30, 50, 70, 100, 150, 200, 500, 1000};
```
Customize what size pt bins you want to look at, update your initialized array size, and move on to the next step.
#### Updating Other Methods
After this bin update, there are a bunch of method calls below the line that was just updated that look like this:
```
  BEff_Dptbins_b    = fs->make<TH1D>("BEff_Dptbins_b   ","",9,ptbinsB); BEff_Dptbins_b->Sumw2();
  BEff_Dptbins_c    = fs->make<TH1D>("BEff_Dptbins_c   ","",9,ptbinsB); BEff_Dptbins_c->Sumw2();
  BEff_Dptbins_udsg = fs->make<TH1D>("BEff_Dptbins_udsg","",9,ptbinsB); BEff_Dptbins_udsg->Sumw2();
  BEffTight_Nptbins_b      = fs->make<TH1D>("BEffTight_Nptbins_b     ","",9,ptbinsB); BEffTight_Nptbins_b->Sumw2();
  BEffTight_Nptbins_c      = fs->make<TH1D>("BEffTight_Nptbins_c     ","",9,ptbinsB); BEffTight_Nptbins_c->Sumw2();
  BEffTight_Nptbins_udsg   = fs->make<TH1D>("BEffTight_Nptbins_udsg  ","",9,ptbinsB); BEffTight_Nptbins_udsg->Sumw2();
  BEffMed_Nptbins_b      = fs->make<TH1D>("BEffMed_Nptbins_b     ","",9,ptbinsB); BEffMed_Nptbins_b->Sumw2();
  BEffMed_Nptbins_c      = fs->make<TH1D>("BEffMed_Nptbins_c     ","",9,ptbinsB); BEffMed_Nptbins_c->Sumw2();
  BEffMed_Nptbins_udsg   = fs->make<TH1D>("BEffMed_Nptbins_udsg  ","",9,ptbinsB); BEffMed_Nptbins_udsg->Sumw2();
  BEffLoose_Nptbins_b      = fs->make<TH1D>("BEffLoose_Nptbins_b     ","",9,ptbinsB); BEffLoose_Nptbins_b->Sumw2();
  BEffLoose_Nptbins_c      = fs->make<TH1D>("BEffLoose_Nptbins_c     ","",9,ptbinsB); BEffLoose_Nptbins_c->Sumw2();
  BEffLoose_Nptbins_udsg   = fs->make<TH1D>("BEffLoose_Nptbins_udsg  ","",9,ptbinsB); BEffLoose_Nptbins_udsg->Sumw2();
  ```
Where the number 9 is now, this number will need to be updated to your array initialization number minus 1.

After this, you can save, exit, and compile, and then move onto the [config file](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/python/befficiency_patjets_cfg.py). You will put the file(s) which you wish to run efficiencies on here:
```
##### ------- This is a test file
process.source = cms.Source("PoolSource",
        fileNames = cms.untracked.vstring(
        'root://eospublic.cern.ch//eos/opendata/cms/MonteCarlo2012/Summer12_DR53X/TTbar_8TeV-Madspin_aMCatNLO-herwig/AODSIM/PU_S10_START53_V19-v2/00000/04FCA1D5-E74C-E311-92CE-002590A887F0.root'))
```
and change the name of whatever you wish your output file to be called here:
```
process.TFileService = cms.Service(
    "TFileService", fileName=cms.string("flavortagefficiencies.root"))
```
Once this is complete, you can run the [config file](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/python/befficiency_patjets_cfg.py) for your efficiencies. 

#### Run Complete
Once your run is complete, in the 'BTagging' branch there should be a file called [plotBeff.C](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/plotBeff.C). This file is set up to show you a graph of your efficiencies that was calculated, as well as, output of your efficiencies that you calculated. To run this code, updated your output file name here:
```
void plotBeff(){

  TFile *_file0 = TFile::Open("flavortagefficiencies.root"); // your file name goes here "Hadd2016.root"
```
Save, exit, then open this file in root like such: 
```
root plotBeff.c
```
The graph and output should appear through root. An example of what the output should look like is this:
```
NEW EFFs.

B FLAVOR Med 2011
pT > 0.000000, eff = 0.263407
pT > 25.000000, eff = 0.548796
pT > 50.000000, eff = 0.656801
pT > 75.000000, eff = 0.689167
pT > 100.000000, eff = 0.697911
pT > 125.000000, eff = 0.700187
pT > 150.000000, eff = 0.679236
pT > 200.000000, eff = 0.625296
pT > 400.000000, eff = 0.389831
pT > 800.000000, eff = 0.400000
C FLAVOR Med 2011
pT > 0.000000, fake = 0.065630
pT > 25.000000, fake = 0.161601
pT > 50.000000, fake = 0.209222
pT > 75.000000, fake = 0.242979
pT > 100.000000, fake = 0.223005
pT > 125.000000, fake = 0.210210
pT > 150.000000, fake = 0.225191
pT > 200.000000, fake = 0.227437
pT > 400.000000, fake = 0.153846
pT > 800.000000, fake = 0.000000
L FLAVOR Med 2011
pT > 0.000000, fake = 0.002394
pT > 25.000000, fake = 0.012683
pT > 50.000000, fake = 0.011459
pT > 75.000000, fake = 0.012960
pT > 100.000000, fake = 0.011424
pT > 125.000000, fake = 0.011727
pT > 150.000000, fake = 0.011302
pT > 200.000000, fake = 0.014760
pT > 400.000000, fake = 0.011628
pT > 800.000000, fake = 0.000000
```
## Implementation in POET



!!! Warning
    This page is under construction
