# Tag and Probe

The **Tag and Probe** method is an experimental procedure commonly used in particle physics that allows to measure a process’ efficiency directly from data. The procedure provides an unbiased sample of probe objects that can be then used to measure the efficiency of a particular selection criteria.

## Tag and Probe method

This method is a data-driven technique and it is based on decays of known ressonances in pair of particles. The decaying muons are labeled according to the following criteria:

- **Tag muon**: well identified, triggered muon (tight selection criteria).
- **Probe muon**: unbiased set of muon candidates (very loose selection criteria), either passing or failing the criteria for which the eciency is to be measured.

Tag muon are employed to trigger the presence of a resonance decay while probe muons, paired to tag muons, will be used for getting efficiency due its' unbiased characteristic.

## CMS Efficiency

The efficiency will be given by the fraction of probe muons that pass a given criteria (in this case, the [Muon ID](#cms-muon-identification-and-reconstruction) which is explained below):

<img width="300px" src="../../../../images/analysis/cmsefficiency/efficiency.svg" alt="Efficiency equation">

The denominator corresponds to the number of resonance candidates (tag+probe pairs) reconstructed in the dataset. The numerator corresponds to the subset for which the probe passes the criteria.

## CMS Muon identification and reconstruction

In the standard CMS reconstruction for proton-proton collisions, tracks are first reconstructed independently in the inner tracker and in the muon system. Based on these objects, three reconstruction approaches are used:

- **Tracker Muon** reconstruction:  all tracker tracks with pT > 0.5 GeV/c and total momentum p > 2.5 GeV/c are considered as possible muon candidates, and are extrapolated to the muon system taking into account the magnetic field;

- **Standalone Muon** reconstruction: all tracks of the segments reconstructed in the muon chambers (performed using segments and hits from Drift Tubes in the barrel region, Cathode Strip Chambers and Resistive Plates Chambers in the endcaps) are used to generate “seeds” consisting of position and direction vectors and an estimate of the muon transverse momentum;

- **Global Muon** reconstruction: starts from a Standalone reconstructed muon track and extrapolates its trajectory from the innermost muon station through the coil and both calorimeters to the outer tracker surface.

These are illustrated below:

![Muons identification](/images/analysis/cmsefficiency/muons_id.png)

!!! Note
	You can find more details concerning CMS Muon Identification and reconstruction in this paper [JINST 7 (2012) P10002](https://doi.org/10.1088/1748-0221/7/10/P10002).