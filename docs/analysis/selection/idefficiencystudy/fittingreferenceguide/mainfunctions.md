# Main Functions

## get_conditions(...)
```cpp
string* get_conditions(int bin_n, double* bins, string quantity)
```
Outputs ```conditions``` that specifie the cuts to be applied to the dataset.

## doFit(...)
```cpp
double* doFit(string condition, string MuonID_str, bool save = TRUE) // RETURNS ARRAY WITH [yield_all, yield_pass, err_all, err_pass]
```
Function that handles the fitting. Has as an input a string ```condition``` that specifies the cut to be applied to the dataset (The location to the ```.root```is set inside the function).
string ```MuonID_str``` specifies the Muon ID that we want to study. 

## McYield(...)
```cpp
double* McYield(string condition)
```
Returns number yield of Monte Carlo data (data is only signal).

## make_hist(...)
```cpp
TH1F* make_hist(string name, double** values, int qnt, int bin_n, Double_t* binning, bool IsDataMc, bool DRAW = FALSE)
```
Generates **TH1F*** histograms direclty from ```values``` which stores ```doFit```'s outputs. ```qnt``` specifies if the histogram stores data from All muons or from Probe muons.

## get_efficiency(...)
```cpp
TEfficiency* get_efficiency(TH1F* ALL, TH1F* PASS)
```
Function used to calculate the efficiency.

## change_bin(...)
```cpp
void change_bin(string condition, string hist_file = "Histograms_Run2011.root")
```
Once the Macro ```Efficiency.C```finishes running, sometimes we are left with poor fit results (sometimes the results are terrible on a specific bin!). This functions allows changes on a specific bin. It is recommended to change the initial conditions of the fitting parameters, on the ```doFit```function.
# Auxiliary Functions

## get_TTree_from_ntupple(...)
```cpp
void get_TTree_from_ntupple()
```
This function merges two seperate ```TTree``` files into one.