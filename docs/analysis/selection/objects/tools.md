# Common tools for physics objects

!!! Warning
    This page covers the access to objects from Run-1 AOD format. Run-2 formats are to be added. The code snippet need to be updated to correspond the example code in [POET](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/MuonAnalyzer.cc). Work in progress.

All CMS physics objects allow you to access important kinematic quantities in a
common way. All objects have associated energy-momentum vectors, typically
constructed using **transverse momentum, pseudorapdity, azimuthal angle, and
mass or energy**.

## 4-vector access functions

The previous page shows how to access a collection of muons in an EDAnalyzer.
The following member functions are available for muons, electrons, photons, tau leptons, and jets.
We will use the example of a loop over the muon collection shown previously:

```cpp
for (auto mu = mymuons->begin(); mu != mymuons->end(); mu++) {

    // minimal set to build a ROOT TLorentzVector
    double tranvserve_momentum = mu->pt();
    double pseudorapidity = mu->eta();
    double azimuthal_angle = mu->phi();
    double mass = mu->mass();

    // electric charge
    double charge = mu->charge();

    // direct 4-vector access
    math::XYZLorentzVector four_momentum = mu->p4();

    // some additional methods
    double energy = mu->energy();
    double transverse_mass = mu->mt();
    double transverse_energy = mu->et();
    double polar_angle = mu->theta();
    double rapidity = mu->y(); // or mu->rapidity()
    double x_momentum = mu->px(); // similar for y, z.    

}
```

These and other basic kinematic methods are [defined here in CMSSW](https://github.com/cms-sw/cmssw/blob/CMSSW_5_3_X/DataFormats/Candidate/interface/LeafCandidate.h).

## Track access functions

Many objects are also connected to tracks from the CMS tracking detectors. Information from
tracks provides other kinematic quantities that are common to multiple types of objects.

### Muon tracks

From a muon object, we can access the associated track while looping over muons via the `globalTrack` method:

```cpp
auto trk = mu->globalTrack(); // muon track
```

Often, the most pertinent information about an object (such as a muon) to access from its
associated track is its **impact parameter** with respect to the primary interaction vertex.
Since muons can also be tracked through the muon detectors, we first check if the track is
well-defined, and then access impact parameters in the xy-plane (`dxy` or `d0`) and along
the beam axis (`dz`), as well as their respective uncertainties.

``` cpp

if (trk.isNonnull()) {
   value_mu_dxy[value_mu_n] = trk->dxy(pv);
   value_mu_dz[value_mu_n] = trk->dz(pv);
   value_mu_dxyErr[value_mu_n] = trk->d0Error();
   value_mu_dzErr[value_mu_n] = trk->dzError();
}
```

### Electron tracks

Electron's charge and track impact parameter values can be accessed and stored following the examples set for muons. Electron tracks are found using the Gaussian-sum filter method `gsfTrack`:

``` cpp
auto trk = it->gsfTrack(); // electron track
```

To access and store the values, code needs to be added in three places:

Declarations:

``` cpp
int value_el_charge[max_el];
float value_el_dxy[max_el];
float value_el_dxyErr[max_el];
float value_el_dz[max_el];
float value_el_dzErr[max_el];

tree->Branch("Electron_charge", value_el_charge, "Electron_charge[nElectron]/I");
tree->Branch("Electron_dxy", value_el_dxy, "Electron_dxy[nElectron]/F");
tree->Branch("Electron_dxyErr", value_el_dxyErr, "Electron_dxyErr[nElectron]/F");
tree->Branch("Electron_dz", value_el_dz, "Electron_dz[nElectron]/F");
tree->Branch("Electron_dzErr", value_el_dzErr, "Electron_dzErr[nElectron]/F");
```

!!! Warning
    The snippet above with lines starting with `tree` expects that variable are written out in a root file.
    A link to a minimal example is needed.

And access values in the electron loop. The format is identical to the muon loop!

``` cpp
value_el_charge[value_el_n] = it->charge();

auto trk = it->gsfTrack();
value_el_dxy[value_el_n] = trk->dxy(pv);
value_el_dz[value_el_n] = trk->dz(pv);
value_el_dxyErr[value_el_n] = trk->d0Error();
value_el_dzErr[value_el_n] = trk->dzError();
```

## Matching to generated particles

Simulated files also contain information about the generator-level particles that
were propagated into the showering and detector simulations. Physics objects can
be matched to these generated particles spatially.

The [AOD2NanoAOD tool](https://github.com/cms-opendata-analyses/AOD2NanoAODOutreachTool/tree/2012) is an example code extracting objects from AOD file and storing them in an output file. In its [analyzer code](https://github.com/cms-opendata-analyses/AOD2NanoAODOutreachTool/blob/2012/src/AOD2NanoAOD.cc), it sets up several utility functions for matching: `findBestMatch`,
`findBestVisibleMatch`, and `subtractInvisible`. The `findBestMatch` function takes
generated particles (with an automated type `T`) and the 4-vector of a physics
object. It uses angular separation to find the closest generated particle to the
reconstructed particle:

``` cpp
template <typename T>
int findBestMatch(T& gens, reco::Candidate::LorentzVector& p4) {

  # initial definition of "closest" is really bad
  float minDeltaR = 999.0;
  int idx = -1;

  # loop over the generated particles
  for (auto g = gens.begin(); g != gens.end(); g++) {
    const auto tmp = deltaR(g->p4(), p4);

    # if it is closer, overwrite the definition of closest
    if (tmp < minDeltaR) {
      minDeltaR = tmp;
      idx = g - gens.begin();
    }
  }
  return idx; # return the index of the match
}
```

The other utility functions are similar, but correct for generated particles that
decay to neutrinos, which would affect the "visible" 4-vector.

In the AOD2NanoAOD tool, muons are matched only to "interesting" generated particles, which
are all the leptons and photons (PDG ID 11, 13, 15, 22). Their generator status must be 1,
indicating a final-state particle after any radiation chain.

``` cpp
if (!isData){
   value_gen_n = 0;
   
   for (auto p = selectedMuons.begin(); p != selectedMuons.end(); p++) {

      // get the muon's 4-vector
      auto p4 = p->p4();

      // perform the matching with a utility function
      auto idx = findBestVisibleMatch(interestingGenParticles, p4);

      // if a match was found, save the generated particle's information
      if (idx != -1) {
        auto g = interestingGenParticles.begin() + idx;

  // another example of common 4-vector access functions!
         value_gen_pt[value_gen_n] = g->pt();
         value_gen_eta[value_gen_n] = g->eta();
         value_gen_phi[value_gen_n] = g->phi();
         value_gen_mass[value_gen_n] = g->mass();

  // gen particles also have ID and status from the generator
         value_gen_pdgid[value_gen_n] = g->pdgId();
         value_gen_status[value_gen_n] = g->status();

  // save the index of the matched gen particle
         value_mu_genpartidx[p - selectedMuons.begin()] = value_gen_n;
         value_gen_n++;
      }
   }
}
```

<!-- ## Challenge: electron matching

Match selected electrons to the interesting generated particles.
Compile your code and run over the simulation test file. Using the
ROOT TBrowser, look at some histograms of the branches you've added to the tree throughout this
episode.

``` console
$ scram b
$ cmsRun configs/simulation_cfg.py
$ root -l output.root
[0] TBrowser b
```

## Solution

The structure for this matching exercise is identical to the muon matching segment. Loop over selected electrons, use the findBestVisibleMatch function to match it to an "interesting" particle and then to a jet.

``` cpp
>>// Match electrons with gen particles and jets
>>for (auto p = selectedElectrons.begin(); p != selectedElectrons.end(); p++) {
>>  // Gen particle matching
>>  auto p4 = p->p4();
>>  auto idx = findBestVisibleMatch(interestingGenParticles, p4);
>>  if (idx != -1) {
>>    auto g = interestingGenParticles.begin() + idx;
>>    value_gen_pt[value_gen_n] = g->pt();
>>    value_gen_eta[value_gen_n] = g->eta();
>>    value_gen_phi[value_gen_n] = g->phi();
>>    value_gen_mass[value_gen_n] = g->mass();
>>    value_gen_pdgid[value_gen_n] = g->pdgId();
>>    value_gen_status[value_gen_n] = g->status();
>>    value_el_genpartidx[p - selectedElectrons.begin()] = value_gen_n;
>>    value_gen_n++;
>>  }
>>
>>  // Jet matching
>>  value_el_jetidx[p - selectedElectrons.begin()] = findBestMatch(selectedJets, p4);
>>}

``` -->