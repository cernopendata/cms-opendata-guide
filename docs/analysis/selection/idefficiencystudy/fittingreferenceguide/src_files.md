# Src files

In this section there is a brief explanation for each file in `src/` folder. In general, this files are headers called by main files defined on the section [Overview](overview.md).

## 📄 create_TH2D.h
```cpp
TH2D* create_TH2D(const char* name, const char* title, string xquantity, string yquantity, int nbinsx, int nbinsy,
	double* xbins, double* ybins)
```
Create a empty TH2D histogram according `xquantity` and `yquantity` variables. these varibles supports `"Pt"`, `"Eta"` and `"Phi"` values.

## 📄 create_folder.h
```cpp
void create_folder(const char* folderPath, bool deleteOld = false)
```
This function creates folder path recursively. If `deleteOld` is true, it deleted the old folder if the path already exists.

## 📄 get_efficiency.h
```cpp
TEfficiency* get_efficiency(TH1D* all, TH1D* pass, string quantity, string MuonId, string prefix_name = "", bool shouldWrite = false)
```
Function used to calculate the efficiency. The `MuonId`, `quantity` and `prefix_name` are used to set the name and title of `TEfficiency*`. If `shouldWrite` is true, it writes the result in any root file opened.

## 📄 get_efficiency_2D.h
```cpp
TEfficiency* get_efficiency_2D(TH2D* all, TH2D* pass, string xquantity, string yquantity, string MuonId, string prefix_name = "", bool shouldWrite = false)
```
Function used to calculate the 2D efficiency. The `MuonId`, `xquantity`, `yquantity` and `prefix_name` are used to set the name and title of `TEfficiency*`. If `shouldWrite` is true, it writes the result in any root file opened.

## 📄 get_efficiency_TH2D.h
```cpp
TH2D* get_efficiency_TH2D(TH2D* hall, TH2D* hpass, string xquantity, string yquantity, string MuonId, string prefix_name = "")
```
Function used to calculate the 2D efficiency. The `MuonId`, `xquantity`, `yquantity` and `prefix_name` are used to set the name and title of `TEfficiency*`. If `shouldWrite` is true, it writes the result in any root file opened.

Same function idea as `TEfficiency* get_efficiency_2D(...)`, but it creates a `TH2D` objects instead which allows better control of uncertainty calculus.

## 📄 make_TH1D.h
```cpp
TH1D* make_TH1D(string name, double** values, int index, double* bins, int nbins, string quantity = "", bool draw = false)
```
Creates **TH1D*** histogram direclty from `values` which stores `doFit`'s outputs. 

* `int index` is related with the information above: `0` means all histogram and `1` means pass histogram. Choose the number due the histogram you are looking to make.
* `double* bins` is used to set histogram bins limits.
* `int nbins` represents the number of bins in `double* bins`.
* `string quantity` supports `"Pt"`, `"Eta"` and `"Phi"` values.
* If `bool draw` it draws the plot on screen.

## 📄 yields_n_errs_to_TH2Ds_bin.h
```cpp
void yields_n_errs_to_TH2Ds_bin(TH2D* hist2d_all, TH2D* hist2d_pass, int x, int y, double* yields_n_errs)
```
This function fills `hist2d_all` and `hist2d_pass` histogram in cell (x,y) with `yields_n_errs` which is a output from `doFit` functions.

## 📂 dofits

Here is stored functions that measures the yields and errors from each bin fit.

The return from each function follows this structure: `[yield_all, yield_pass, error_all, error_pass]`.

Functions in this files are defined by:

```cpp
double* doFit(string condition, string MuonId, const char* savePath = NULL)
```

* `string condition` selects the bin conditions.
* `string MuonId` supports `"trackerMuon"`, `"standaloneMuon"` and `"globalMuon"` values.
* `const char* savePath ` where the fit output file from the fit will be saved for further checks.
