#  Object Uncertainty


![Scale Factors](https://twiki.cern.ch/twiki/pub/CMSPublic/PhysicsResultsBTV13001/mistag_csvm.pdf)

In simulation, the efficiency for tagging b quarks as b jets is defined as the number of "real b jets" (jets spatially matched to generator-level b hadrons) tagged as b jets divided by the number of real b jets. The efficiency for mis-tagging c or light quarks as b jets is similar (real c/light jets tagged as b jets / real c/light jets). These values are typically computed as functions of the momentum or pseudorapidity of the jet. The "real" flavor of the jet is accessed most simply by creating pat::Jet objects instead of reco::Jet objects, as we will see in the next episode.

Scale factors to increase or decrease the number of b-tagged jets in simulation can be applied in a number of ways, but typically involve weighting simulation events based on the efficiencies and scale factors relevant to each jet in the event. Scale factors for the CSV algorithm are available for Open Data and involve extracting functions from a comma-separated-values file. Details and usage reference can be found here:

-[Explanation](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Data_MC_Scale_Factors)
-[Data file for the CSV algorithm](https://twiki.cern.ch/twiki/pub/CMSPublic/BtagRecommendation2011OpenData/CSV.csv)
-[Examples of application methods](https://twiki.cern.ch/twiki/bin/view/CMSPublic/BtagRecommendation2011OpenData#Methods_to_Apply_b_Tagging_Effic)

### Data file for the CSV algorithm
[This file](https://twiki.cern.ch/twiki/pub/CMSPublic/BtagRecommendation2011OpenData/CSV.csv) contains a lot of useful information for calculating scale factors. 


## Calculating Efficiencies 


## Implementation in POET



!!! Warning
    This page is under construction
