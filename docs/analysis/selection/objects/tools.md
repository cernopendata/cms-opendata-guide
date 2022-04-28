# Common tools for physics objects

!!! Warning
    This page covers the access to objects from Run-1 AOD format. Run-2 formats are to be added.

Many of the most important kinematic quantities defining a physics object are accessed in a common way across all the objects. All objects have associated energy-momentum vectors, typically constructed using **transverse momentum, pseudorapdity, azimuthal angle, and mass or energy**.

## 4-vector access functions

In [MuonAnalyzer.cc](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/MuonAnalyzer.cc), the muon four-vector elements are accessed as shown below. The values for each muon are stored into an array, which will become a branch in a ROOT TTree.

```cpp
for (reco::MuonCollection::const_iterator itmuon=mymuons->begin(); itmuon!=mymuons->end(); ++itmuon){
  if (itmuon->pt() > mu_min_pt) {

    muon_e.push_back(itmuon->energy());
    muon_pt.push_back(itmuon->pt());
    muon_eta.push_back(itmuon->eta());
    muon_phi.push_back(itmuon->phi());

    muon_px.push_back(itmuon->px());
    muon_py.push_back(itmuon->py());
    muon_pz.push_back(itmuon->pz());

    muon_mass.push_back(itmuon->mass());

}
```

 The same type of kinematic member functions are used in all the different analyzers in the [src/ directory of the POET example code](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/tree/2012/PhysObjectExtractor/src). These and other basic kinematic methods are defined in the [LeafCandidate class](https://github.com/cms-sw/cmssw/blob/CMSSW_5_3_X/DataFormats/Candidate/interface/LeafCandidate.h) of the CMSSW DataFormats package (rendered for maybe easier readability in the [CMSSW software documentation](https://cmsdoxygen.web.cern.ch/cmsdoxygen/CMSSW_5_3_30/doc/html/dc/d78/classreco_1_1LeafCandidate.html)).

## Track access functions

Many objects are also connected to tracks from the CMS tracking detectors. Information from
tracks provides other kinematic quantities that are common to multiple types of objects.

From a muon object, we can access the associated track while looping over muons via the `globalTrack` method:

```cpp
auto trk = mu->globalTrack(); // muon track
```

Often, the most pertinent information about an object (such as a muon) to access from its
associated track is its **impact parameter** with respect to the primary interaction vertex.
Since muons can also be tracked through the muon detectors, we first check if the track is
well-defined, and then access impact parameters in the xy-plane (`dxy` or `d0`) and along
the beam axis (`dz`), as well as their respective uncertainties. They can be accessed as shown
in this code snippet from [MuonAnalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/src/MuonAnalyzer.cc):

``` cpp
    auto trk = itmuon->globalTrack();
    if (trk.isNonnull()) {
      muon_dxy.push_back(trk->dxy(pv));
      muon_dz.push_back(trk->dz(pv));
      muon_dxyErr.push_back(trk->d0Error());
      muon_dzErr.push_back(trk->dzError());
    }
```

Note that the tracking method depends on the object, the electron tracks are found using the Gaussian-sum filter method `gsfTrack`:

``` cpp
auto trk = it->gsfTrack(); // electron track
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