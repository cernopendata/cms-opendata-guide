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
Once you have you efficiencies, you can then put them in to the 3 respective functions for storing efficiencies. Here is the b tag efficiencies function:
```
double
PatJetAnalyzer::getBtagEfficiency(double pt){
  if(pt < 25) return 0.263407;
  else if(pt < 50) return 0.548796;
  else if(pt < 75) return 0.656801;
  else if(pt < 100) return 0.689167;
  else if(pt < 125) return 0.697911;
  else if(pt < 150) return 0.700187;
  else if(pt < 200) return 0.679236;
  else if(pt < 400) return 0.625296;
  else return 0.394916;
}
```

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

### Calculating Weights
Once these are updated to their desired state, weight calculating can happen! In the analyzers in the for loop is where the weight calculating occurs. The first part of the calculating that is important is
`
if (jet_btag.at(value_jet_n) > 0.679)
`. This check to see whether or not the jet made the medium cut that we were looking for. If it did, we go into the part of the calculating that looks like this:
````
  if(abs(hadronFlavour) == 5){
	    eff = getBtagEfficiency(corrpt);
	    SF = getBorCtagSF(corrpt, jet_eta.at(value_jet_n));
	    SFu = SF + uncertaintyForBTagSF(corrpt, jet_eta.at(value_jet_n));
	    SFd = SF - uncertaintyForBTagSF(corrpt, jet_eta.at(value_jet_n));
	  } else if(abs(hadronFlavour) == 4){
	    eff = getCtagEfficiency(corrpt);
	    SF = getBorCtagSF(corrpt, jet_eta.at(value_jet_n));
	    SFu = SF + (2 * uncertaintyForBTagSF(corrpt, jet_eta.at(value_jet_n)));
	    SFd = SF - (2 * uncertaintyForBTagSF(corrpt, jet_eta.at(value_jet_n)));
	  } else {
	    eff = getLFtagEfficiency(corrpt);
	    SF = getLFtagSF(corrpt, jet_eta.at(value_jet_n));
	    SFu = SF + ( uncertaintyForLFTagSF(corrpt, jet_eta.at(value_jet_n)));
	    SFd = SF - ( uncertaintyForLFTagSF(corrpt, jet_eta.at(value_jet_n)));
	  }
````
This section first finds which type of jet it is (b = 5, c = 4, and light = anything else) and then gets the efficiency for the respected jet as well as calculates its scale factor. It also calculates its up and down quarked scale factors of the jet. Once this is done, the calculation part of the if statement can be calculated.
```
          MC *= eff;
	  btagWeight *= SF * eff;
	  btagWeightUp *= SFu * eff;
	  btagWeightDn *= SFd * eff;
```
A similar process with a little bit different end calculation is done in the else statement of the very first if statement if the jet did not meet the medium cut. 

Once the for loop has finished, a final calculation for the event weights is done.
```
    btagWeight = (btagWeight/MC);
    btagWeightUp = (btagWeightUp/MC);
    btagWeightDn = (btagWeightDn/MC);
```

NOTE: There are many ways to go about calculating event weights. This [link](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Methods_to_Apply_b_Tagging_Effic) shows a couple of the ways to calculate the event weights. In POET, method 1a is the method of event calculating used.

### Uncertainties
As we just saw in the calculating weights section above ,there are uncertainties that need to be considered. These uncertainties are actually already taken into account in the .csv file. When looking at the scale factor equation, there should be a main equation followed by either an addition or subtraction of a number which is the uncertainty.
#### Uncertainties for each flavor
In POET, there are 2 functions for the uncertainty, one for the b tag uncertainty and one for the light flavor tag uncertainty. The reason that there is not one specifically for c tagged jets is because c tagged jet's uncertainty is two times that of the b tagged jet's uncertainty so you can simply multiply the b tag uncertainty call by two as seen here `SFu = SF + (2 * uncertaintyForBTagSF(corrpt, jet_eta.at(value_jet_n)));`

Here is what the b tag uncertainty function looks like:
```
double
PatJetAnalyzer::uncertaintyForBTagSF( double pt, double eta){
  if(fabs(eta) > 2.4 or pt<20.) return 0;
  if(pt < 30) return 0.0466655;
  else if(pt < 40) return 0.0203547;
  else if(pt < 50) return 0.0187707;
  else if(pt < 60) return 0.0250719;
  else if(pt < 70) return 0.023081;
  else if(pt < 80) return 0.0183273;
  else if(pt < 100) return 0.0256502;
  else if(pt < 120) return 0.0189555;
  else if(pt < 160) return 0.0236561;
  else if(pt < 210) return 0.0307624;
  else if(pt < 260) return 0.0387889;
  else if(pt < 320) return 0.0443912;
  else if(pt < 400) return 0.0693573;
  else if(pt < 500) return 0.0650147;
  else return 0.066886;
}
```
#### Storing uncertainties



!!! Warning
    This page is under construction
