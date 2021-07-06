# B Tag Uncertainty

## Scale Factors
In simulation, 
- Efficiency for tagging b quarks as b jets: the number of "real b jets" (jets spatially matched to generator-level b hadrons) tagged as b jets divided by the number of real b jets. 
- Efficiency for mis-tagging c or light quarks as b jets: real c/light jets tagged as b jets / real c/light jets. 

These values are typically computed as functions of the momentum or pseudorapidity of the jet. The "real" flavor of the jet is accessed most simply by creating pat::Jet objects instead of reco::Jet objects.

Scale factors to increase or decrease the number of b-tagged jets in simulation can be applied in a number of ways, but typically involve weighting simulation events based on the efficiencies and scale factors relevant to each jet in the event. Scale factors for the CSV algorithm are available for Open Data and involve extracting functions from a comma-separated-values file. A helpful link for scale factors can be found [here](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Data_MC_Scale_Factors).

### Applying Scale Factors

#### Calculating Efficiencies
The [BTagging folder](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/tree/master/BTagging) of PhysObjectExtractorTool ([POET](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool)) is used for calculating the efficiency for tagging each flavor of jet as a b quark, as a function of the jet momentum with the file [WeightAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/src/WeightAnalyzerBEff.cc). The purpose of this file is to set up jet momentum histograms for numerators and denominators of efficiency histograms. The way that this is done is in a for loop that loops over the jets, checks their flavor, checks their btagging pass/fail for 3 working points, and then fills the histograms according to that information. These historgrams are then stored in an output file.
The place configure the input, output, and parameters are in the [config file](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/python/befficiency_patjets_cfg.py).

#### Access Efficiencies

functions in code

#### Access Scale Factors

[This file](https://twiki.cern.ch/twiki/pub/CMSPublic/BtagRecommendation2011OpenData/CSV.csv) contains a lot of useful information for calculating scale factors. When looking at the file itself however, some of the column headers are titled oddly or do not give helpful information on how to navigate the column. Some important titles to giver more context to are as follows: 
- OperatingPoint - This is the light (0), medium (1), or tight (2) cut of the light flavored jet.
- formula - This is the equation for calculating the scale factor, where x is the momentum of the jet.
- jetFlavor - b = 0, c = 1, udsg = 2.

Sorting Columns and creating filters with the .csv file can make accessing and finding sepcific scale factor equations. For example, filtering the OperatingPoint column to only show "1" will give you only medium cut jet information. Other useful information about the .csv file can be found [here](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BTagCalibration).

The scale factor equations from the folumla column have been implemented in POET! In PatJetAnalyzer there are 2 functions, one for b and c flavored jets and one for light flavored jets, that return the scale factor of the jet depending on the momentum of the jet. Below is the b and c tag function.
```
double
PatJetAnalyzer::getBorCtagSF(double pt, double eta){
  if (pt > 670.) pt = 670;
  if(fabs(eta) > 2.4 or pt<20.) return 1.0;

  return 0.92955*((1.+(0.0589629*pt))/(1.+(0.0568063*pt)));
}
```
More useful information about scale factors can be found here [here](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Data_MC_Scale_Factors).

FIXME: Point to / example of your SF functions that implement the CSV content (same for everybody, no editing needed!)

### Calculating Weights
FIXME: Show Code

There are many ways to go about calculating event weights. This [link](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Methods_to_Apply_b_Tagging_Effic) shows a couple of the ways to calculate the event weights. In POET, method 1a is the method of event calculating used.



### Uncertainties

#### Uncertainties for each flavor

#### Storing uncertainties







## ____________________________________________________________________________________







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
Once your run is complete, in the 'BTagging' branch there should be a file called [plotBeff.C](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/BTagging/plotBeff.C). This file is set up to show you a histogram of your efficiencies that were calculated in jet mopmentum bins, as well as, write output of your efficiencies that you calculated in those bins. To run this code, updated your output file name here:
```
void plotBeff(){

  TFile *_file0 = TFile::Open("flavortagefficiencies.root"); // your file name goes here "Hadd2016.root"
```
Save, exit, then open this file in root like such: 
```
root plotBeff.c
```
The graph and output should appear through root. An example of what the graph should look like is this:


## Implementation in POET



!!! Warning
    This page is under construction
