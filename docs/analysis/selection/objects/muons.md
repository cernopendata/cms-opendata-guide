# Muons

## Introduction

The muons are measured in the CMS experiment combining the information from the [inner tracker](https://cms.cern/index.php/detector/identifying-tracks) and the [muon system](https://cms.cern/detector/detecting-muons). The signals from these systems are processed with CMSSW through [subsequent steps](../../../cmssw/cmsswdatamodel.md) to form muon candidates which are then available in the muon collection of the data files.

The [Physics Objects page](objects.md) shows how to access muon collections, and which header files should be included in the C++ code in order to access all of their class information. The [Common Tools page](tools.md) gives instructions to access all the basic kinematic information about any physics object.

This page explains how muon information is used to identify muon, i.e. to separate “real” objects from “fakes”.

## Muon identification

The muon object has member functions available which can directly be used to select muon with "loose" or "tight" selection criteria. These are the corresponding lines in [MuonAnalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/MuonAnalyzer.cc):

``` cpp
    muon_tightid.push_back(muon::isTightMuon(*itmuon, *vertices->begin()));
    muon_softid.push_back(muon::isSoftMuon(*itmuon, *vertices->begin()));
```

These functions need the interaction vertex as an input (in addition to the muon properties) and this is provided through the first elemement of the vertex collection `vertices` which gives the best estimate of the interaction point.

In the physics analysis, hard processes that produce large angles between the final state objects are of interest. The final object will be separated from the other objects in the event or be “isolated”. For instance, an isolated muon might be produced in the decay of a W boson. In contrast, a non-isolated muon can come from a weak decay inside a jet.

Muon isolation is calculated from a combination of factors: energy from charged hadrons, energy from neutral hadrons, and energy from photons, all in a cone of radius dR < 0.3 or 0.4 around the muon. It is done as shown in this code snippet from [MuonAnalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/MuonAnalyzer.cc):

``` cpp
    if (itmuon->isPFMuon() && itmuon->isPFIsolationValid()) {
      auto iso03 = itmuon->pfIsolationR03();
      muon_pfreliso03all.push_back((iso03.sumChargedHadronPt + iso03.sumNeutralHadronEt + iso03.sumPhotonEt)/itmuon->pt());
      auto iso04 = itmuon->pfIsolationR04();
      muon_pfreliso04all.push_back((iso04.sumChargedHadronPt + iso04.sumNeutralHadronEt + iso04.sumPhotonEt)/itmuon->pt());
    }
```

More details on the muon identification can be found in the [CMS SWGuide MuonID page](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideMuonId).

## Further muon corrections

There are misalignments in the CMS detector that make the reconstruction of muon momentum biased. The CMS reconstruction software does not fully correct these misalignments and additional corrections are needed to remove the bias. Correcting the misalignments is important when precision measurements are done using the muon momentum, because the bias in muon momentum will affect the results. However, if the measurement is not sensitive to the exact muon momentum, applying these corrections is not necessary.

### The Muon Momentum Scale Corrections

The Muon Momentum Scale Corrections, also known as the Rochester Corrections, are available in the [MuonCorrectionsTool](https://github.com/cms-legacydata-analyses/MuonCorrectionsTool). The correction parameters have been extracted in a two step method. In the first step, initial corrections are obtained in bins of the charge of the muon and the η and ϕ coordinates of the muon track. The reconstruction bias in muon momentum depends on these variables. In the second step, the corrections are fine tuned using the mass of the Z boson.

The corrections for data and Monte Carlo (MC) are different since the MC events start with no biases but they can be induced during the reconstruction. Corrections have been extracted for both data and MC events.

In the MuonCorrectionsTool, the Run1 Rochester Corrections are added to two datasets as an example: a 2012 dataset and a MC dataset. A plot is created to check that the corrections were applied correctly. Creating the plot requires selections and the produced dataset contains only a part of the initial dataset. These selections can be skipped when the plot is not needed and a corrected version of the whole dataset is wanted as a result. Below you can find instructions on how to run the example code, how to apply the corrections to a different dataset and how to apply the corrections when you don't want to create the plot/make the selections. The official code for the Rochester Corrections can be found in the `RochesterCorrections` directory. The example code for applying the corrections is in the `Test` directory.

!!! Warning
    The following example does not need the CMSSW environment but it requires ROOT. This code was written using the ROOT version 6.22.08. If you are using an older version, you might get errors running the code. In this case, try using `rochcor2012wasym_old.h` instead of `rochcor2012wasym.h`. You can do this by changing the first line of `rochcor2012wasym.cc` to `#include "rochcor2012wasym_old.h"`.

### Applying the corrections to data and MC

In the `Test` directory you can find `Analysis.C`, which is the example code for adding the corrections. The main function of `Analysis.C` is simply used for calling the `applyCorrections` function which takes as a parameter the name of the ROOT-file (without the .root-part), path to the ROOT-file, the name of the TTree, a boolean value of whether the file contains data (`true`) or MC (`false`) and a boolean variable of whether you want to correct the whole dataset (`true`) or make the selections needed for the plot (`false`).

``` cpp
void Analysis::main()
{
  // Data
  applyCorrections("Run2012BC_DoubleMuParked_Muons", "root://eospublic.cern.ch//eos/opendata/cms/derived-data/AOD2NanoAODOutreachTool/Run2012BC_DoubleMuParked_Muons.root", "Events", true, false);

  // MC
  applyCorrections("ZZTo2e2mu", "root://eospublic.cern.ch//eos/opendata/cms/upload/stefan/HiggsToFourLeptonsNanoAODOutreachAnalysis/ZZTo2e2mu.root", "Events", false, false);
}
```

The first thing `applyCorrections` does is create a TTree from the ROOT-file. Then variables for holding the values read from the tree are created and branch addresses are set so that the variables are populated when looping over events. An output file, new branches for the corrected values and a few variables needed for the corrections are also created.

``` cpp
int applyCorrections(string filename, string pathToFile, string treeName, bool isData, bool correctAll) {
  // Create TTree from ROOT file
  TFile *f1 = TFile::Open((pathToFile).c_str());
  TTree *DataTree = (TTree*)f1->Get("Events");
  
  //Variables to hold values read from the tree
  int maxmuon=1000;
  UInt_t nMuon = 0;
  Float_t Muon_pt[maxmuon];
  Float_t Muon_eta[maxmuon];
  Float_t Muon_phi[maxmuon];
  Float_t Muon_mass[maxmuon];
  Int_t Muon_charge[maxmuon];

  //Set addresses to make the tree populate the variables when reading an entry
  DataTree->SetBranchAddress("nMuon", &nMuon);
  DataTree->SetBranchAddress("Muon_pt", &Muon_pt);
  DataTree->SetBranchAddress("Muon_eta", &Muon_eta);
  DataTree->SetBranchAddress("Muon_phi", &Muon_phi);
  DataTree->SetBranchAddress("Muon_mass", &Muon_mass);
  DataTree->SetBranchAddress("Muon_charge", &Muon_charge);
```
<!-- markdownlint-disable -->
Next, the events in the TTree are looped over and the corrections are applied to the muons. The boolean variable `correctAll` is used here to determine whether to correct all muons in the dataset or to make the selections required for the plot. The invariant mass of μ<sup>+</sup>μ<sup>-</sup> is used in the plot, which is why the events are filtered to muon pairs with opposite charges.
<!-- markdownlint-restore -->

``` cpp
  // Loop over events
  Int_t nEntries = (Int_t)DataTree->GetEntries();

  for (Int_t k=0; k<nEntries; k++) {
    DataTree->GetEntry(k);
    
    if (correctAll) { // Correct all muons in dataset
      if (nMuon > 0) {
        ...
      }
    } else { // Correct muons that pass the selections
      // Select events with exactly two muons
      if (nMuon == 2 ) {
        // Select events with two muons of opposite charge
        if (Muon_charge[0] != Muon_charge[1]) {
          ...
        }
      }
    }
```

Whether all muons or only selected ones are being corrected, it is done in the loop below that loops over all the muons in an event and applies the corrections. The functions for applying the Rochester Corrections take as a parameter a TLorentzVector, which is a four-vector that describes the muons momentum and energy. A TLorentzVector is created for each muon using the muon's pt, eta, phi and mass. As mentioned earlier, the muon momentum scale corrections are different for data and MC and therefore there are separate functions for both: `momcor_data` and `momcor_mc`. These functions can be found in `rochcor2012wasym.cc` if you want to take a closer look at them.

The corrected values are stored in the same TLorentzVectors after calling the correction functions. The values are then extracted from the TLorentzVecotrs and saved to the new variables. The new TTree is then filled with the new values.

``` cpp
        // Loop over muons in event
        for (UInt_t i=0; i<nMuon; i++) {
          // Create TLorentzVector
          TLorentzVector mu;
          mu.SetPtEtaPhiM(Muon_pt[i], Muon_eta[i], Muon_phi[i], Muon_mass[i]);

          // Apply the corrections
          if (isData) {
            rmcor.momcor_data(mu, Muon_charge[i], runopt, qter);
          } else {
            rmcor.momcor_mc(mu, Muon_charge[i], ntrk, qter);
          }

          // Save corrected values
          Muon_pt_cor[i] = mu.Pt();
          Muon_eta_cor[i] = mu.Eta();
          Muon_phi_cor[i] = mu.Phi();
          Muon_mass_cor[i] = mu.M();
        }
        
        DataTreeCor->Fill();
```
<!-- markdownlint-disable -->
When only the selected muons are being corrected, the code does more than just apply the corrections. Both the uncorrected and corrected invariant mass of μ<sup>+</sup>μ<sup>-</sup> is computed and saved to a branch. The MuonCorrectionsTool plot is made in bins of eta of μ<sup>+</sup> and eta of μ<sup>-</sup> and new branches are filled for those variables.
<!-- markdownlint-restore -->

```cpp
          // Compute invariant mass of the dimuon system
          Dimuon_mass = computeInvariantMass(Muon_pt[0], Muon_pt[1], Muon_eta[0], Muon_eta[1], Muon_phi[0], Muon_phi[1], Muon_mass[0], Muon_mass[1]);

          // Choose positive and negative muons' etas
          if (Muon_charge[0] > 0) {
            Muon_eta_pos = Muon_eta[0];
            Muon_eta_neg = Muon_eta[1];
          } else {
            Muon_eta_pos = Muon_eta[1];
            Muon_eta_neg = Muon_eta[0];
          }
          
          // Compute invariant mass of the corrected dimuon system
          Dimuon_mass_cor = computeInvariantMass(Muon_pt_cor[0], Muon_pt_cor[1], Muon_eta_cor[0], Muon_eta_cor[1], Muon_phi_cor[0], Muon_phi_cor[1], Muon_mass_cor[0], Muon_mass_cor[1]);
```

Finally, the new TTree is written to the output file.

``` cpp
  std::cout << "Writing tree to ouput file" << std::endl;

  //Save the new tree
  DataTreeCor->Write();
```

### Running the code

1. Open ROOT in terminal

   ``` cpp
   root
   ```

2. Compile `muresolution.cc`, `rochcor2012wasym.cc` and `Analysis.C`

   ``` cpp
   .L RochesterCorrections/muresolution.cc++
   .L RochesterCorrections/rochcor2012wasym.cc++
   .L RochesterCorrections/Test/Analysis.C+
   ```

3. Run the main function

   ``` cpp
   Analysis pf
   pf.main()
   ```

4. To create the plot, compile `Plot.C` and run the main function

   ``` cpp
   .L RochesterCorrections/Test/Plot.C+
   main()
   ```

### Applying the corrections to a different dataset

You can use the example code to apply the corrections to different datasets. However, a few changes needs to be made for the code to work correctly. The first thing that needs to be changed is of course the function call in the main function. Call `applyCorrections` using the parameters that correspond your dataset. Remember that for the first boolean parameter `true` means your ROOT file contains data and `false` means it contains MC. For the last parameter, `true` means you want to correct all muons without making selections and `false` means you want to make the selections needed for the MuonCorrectionsTool plot.

``` cpp
void Analysis::main()
{
  // Your dataset
  applyCorrections("nameOfFile", "pathToFile", "treeName", isData, correctAll);
}
```

The second thing you need to do is check the names and data types of the branches in your dataset. For example, instead of the name `nMuon` you might have `numberOfMuons` and instead of data type `Muon_pt[nMuon]` you might have `vector<float> Muon_pt`. The correct name needs to be changed to the branch address and the data type needs to be corrected. If you have vector, you might need to change `Muon_pt[i]` to `Muon_pt->at(i)` or something similiar later in the code. Example:

``` cpp
  //Variables to hold values read from the tree
  int maxmuon=1000;
  UInt_t nMuon = 0;
  vector<float>* Muon_pt;

  //Set addresses to make the tree populate the variables when reading an entry
  DataTree->SetBranchAddress("numberOfMuons", &nMuon);
  DataTree->SetBranchAddress("Muon_pt", &Muon_pt);
```

### Correcting the dataset without making selections

If you want to correct all muons without making the selections needed for the MuonCorrectionsTool plot, simply give `true` as the last parameter when calling `applyCorrections`. The code will then loop through the events, select events with muons and correct the muons.
