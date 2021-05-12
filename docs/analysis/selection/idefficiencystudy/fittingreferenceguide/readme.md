# Calculating Efficiencies using Tag & Probe

## Setup

This project was developed using [ROOT](https://root.cern.ch/root/html534/guides/users-guide/InstallandBuild.html), made available by CERN and the following Datasets:
* [1] [Run2011AMuOnia_mergeNtuple.root](https://drive.google.com/drive/u/0/folders/1Nu9Al7SV1F60TMFxKZVBIMvgEWAdzida)
* [2] [JPsiToMuMu_mergeMCNtuple.root](https://drive.google.com/drive/u/0/folders/1Nu9Al7SV1F60TMFxKZVBIMvgEWAdzida)

From these two datasets, a `.root` file was generated for each MuonId (i.e *Standalone*, *Tracker* or *Global*) using the `get_root.C` and then stored on the `\Data` folder, following the respective hierarchy.

## Fitting Method

The fitting method consists in dividing the quantity we want to use to calculate the efficiency into a certain amout of bins and then fitting the invariant mass of the muons (All and Passing) on the specified region.
To compute the efficiency we simply divide the yield from the fit of the Passing muons by the yield of the fit of All the muons.
The following image tries to illustrate this idea.
  
<img width="500px" src="../../../../../images/analysis/cmsefficiency/fitting_method_large.png">

## WorkFlow

`Efficiency.C` is given as an example of how to use the fitting method to calculate an efficiency. It follows as such:
1. The user has to manually define the bins in which the quantity being studied (i.e. pT, Eta, Phi) will be divided;
2. Generate conditions (that divide the dataset into the defined binned intervals) using ```get_conditions```;
3. Create a loop that fits the invariant mass for each bin using ```doFit```when the dataset consists of real data and ```McYield``` for the Monte Carlo dataset.

## Running

On this repository, do:

```sh
root -l -b -q Efficiency.C
```

## Output
Output images are stored in the `/result` folder.