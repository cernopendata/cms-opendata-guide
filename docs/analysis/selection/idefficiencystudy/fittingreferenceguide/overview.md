# Overview of fitting method

The fitting method folder is structured in folders and main files. Main files are those ones that are used to run the most important codes. Below is a list of folders presented in this method and the files encontered here.

## Fitting method folder structure

The folders contained in fitting method are described below.

| Folder        | Purpose                                                                                     |
|---------------|---------------------------------------------------------------------------------------------|
| 📂 DATA       | Where `.root` with data should be placed for measuring efficiency                           |
| 📂 src        | Where important files related to main code are keeped                                       |
| └ 📂 dofits   | Here it keeps files that are responsible to do the fitting over invariant masses histograms |
| 📂 tests      | Some teste made during the development of this tool                                         |
| 📂 results    | This folder stores the results output and it is created when any code finnish running       |

## Main files

There are six main files in the fitting method. For simple results like the ones obtained in **sideband subtraction method** the file used is efficiency.cpp.

Main files are explained below.



### 📄 simplify_data.cpp

The `simplify_data.cpp` file, as the name sugest, simplify a DATA file obtained from this Tag and Probe tool. It is necessary to simplify due RooFit limitations where fitting method codes here used are based on.

There are two lines responsable for input and output file:

```cpp
TFile *file0  = TFile::Open("INPUT_FILE_PATH.root");
```

```cpp
TFile *fileIO = TFile::Open("OUTPUT_FILE_PATH.root","RECREATE");
```

Every user should run this code firstly to simplify `.root` files on fitting method.



### 📄 efficiency.cpp

This file is responsible to measure the efficiency simple by fitting method as described in this [fitting method](../signalextraction.md#fitting-method) section.

#### Choosing ressonance

Here it include the file that is responsible to fit the ressonance and return the yield obtained with error.

```cpp
//Change if you need
#include "src/dofits/DoFit_Jpsi_Run.h"
```

By default out tool keeps all ressonance fit in the folder `src/dofits`. There are some example there for specific ressonances and fits.

#### Important variables

There are two main parameters to control this code.

```cpp
//Which Muon Id do you want to study?
string MuonId   = "trackerMuon";
```

The `string MuonId` supports `"trackerMuon"`, `"standaloneMuon"` and `"globalMuon"` values.

```cpp
//Which quantity do you want to use?
string quantity = "Pt";     double bins[] = {0., 2.0, 3.4, 4.0, 4.4, 4.7, 5.0, 5.6, 5.8, 6.0, 6.2, 6.4, 6.6, 6.8, 7.3, 9.5, 13.0, 17.0, 40.};
```

`string quantity` supports `"Pt"`, `"Eta"` and `"Phi"` values.

`double bins[]` is used to set histogram bins limits. In the example above, the first bin is [0., 2.), the second is [2., 4.) and so on.

#### Output

There are two output folders in this file by default. They are defined in those lines of code:

```cpp
//Path where is going to save results png for every bin 
const char* path_bins_fit_folder = "results/bins_fit/efficiency/";
```

`path_bins_fit_folder` refers to the path where each individual fit of bins will be stored as `.png`. In this folder you can find every fit made in this method.

```cpp
//Path where is going to save efficiency 
string directoryToSave = string("results/efficiencies/efficiency/") + output_folder_name + string("/");
```

The `directoryToSave` stores the path to save the efficiency result. It is saved as a `.root` file containing passing and total histograms as well the efficiency result histogram.

Informations about the output is printed at end of running.



### 📄 loop_over_efficiencies.cpp

The purpose of this code is rerun the `efficiency.cpp` for differents configurations. This code is not recommended for systematic calculations indeed and it was firstly created for systematic studies only.

#### Important variables

The importants variables to keep in mind are listed below

| Type   | Name                 | Purpose  |
|--------|----------------------|----------|
| double | default_min          | the minimum invariant mass window postion                                |
| double | default_max          | the maximum invariant mass window postion                                |
| bool   | should_loop_muon_id  | if true, it loops over all muons id (tracking, standalone, global)       |
| bool   | should_loop_settings | if true, it loops over all settings presented in set_settings() function |
| int    | setting              | if should_loop_settings is false, it uses only this setting number       |
| bool   | exactly              | This only affect the name of output plots inside `.root`. Its recommended to keep it set to false |

#### set_settings(...)

It is one of four functions presented in this code. Its is called by:

```cpp
void set_settings(int index, bool exactly = false)
```

Inside this function are preset settings that this file runs over. Each setting is associated with a number here named as *index*. This function is responsible to set the *index* configuration to the efficiency for running the `efficiency.cpp` file.

#### loop_settings()

```cpp
void loop_settings()
```

If `should_loop_muon_id` is true, this function is called. It loops over all muon ids: tracking, standalone, global.

#### loop_muon_id()

```cpp
void loop_muon_id()
```

If `should_loop_settings` is true, this function is called. It loops over all settings preset in `set_settings(...)` function.

#### loop_over_efficiencies()

```cpp
void loop_over_efficiencies()
```

It is the main function of this file. It is the function which calls every other function when it is needed.



### 📄 plot_sys_efficiency.cpp

The `plot_sys_efficiency.cpp` code creates a single `.root` with variations made. Unlike the previous code, the `loop_over_efficiencies.cpp`, that makes each source of uncertainty be in a separate .root, this one puts all of them in a single `.root`. This code has been further optimized than his precursor and also as a differential it already calculates the systematic uncertainty. Below it is specified main variables used in this code.

#### Important variables

```cpp
//Which Muon Id do you want to study?
string MuonId   = "trackerMuon";
```

The `string MuonId` supports `"trackerMuon"`, `"standaloneMuon"` and `"globalMuon"` values.

```cpp
//Which quantity do you want to use?
string quantity = "Pt";     double bins[] = {0., 2.0, 3.4, 4.0, 4.4, 4.7, 5.0, 5.6, 5.8, 6.0, 6.2, 6.4, 6.6, 6.8, 7.3, 9.5, 13.0, 17.0, 40.};
```

`string quantity` supports `"Pt"`, `"Eta"` and `"Phi"` values.

`double bins[]` is used to set histogram bins limits. In the example above, the first bin is [0., 2.), the second is [2., 4.) and so on.

Inside `plot_sys_efficiency()`, there is some useful variables too:

| Type   | Name                 | Purpose  |
|--------|----------------------|----------|
| string | path_bins_fit_folder | Stores the path to the output folder where `.png` of fit for each bin made will be |
| string | directoryToSave      | Stores the path to output file |


### 📄 overplot_efficiencies.cpp

The `overplot_efficiencies.cpp` code will take the results of the previous topic and make a single graph containing all its variations and will output a `.png` containing the graph.

#### Important variables

All main variables are in `overplot_efficiencies()`

| Type        | Name                 | Purpose  |
|-------------|----------------------|----------|
| const char* | input_folder_name    | Stores the path to input folder where `.root` is |
| const char* | output_folder_name   | Stores the path to output folder |
| string      | MuonId               | It accepts values of `"trackerMuon"`, `"standaloneMuon"` and `"globalMuon"` |
| string      | quantity             | It accepts values of `"Pt"`, `"Eta"` and `"Phi"` |

Remeber when selecting MuonId and quantity to run `plot_sys_efficiency.cpp` before with same configurations.


### 📄 plot_sys_efficiency_2d.cpp

In order to calculate systematic uncertainties in 2D, it was necessary to create another code: the `plot_sys_efficiency_2d.cpp`. It has a `.root` output containing the efficiency histograms that can be viewed through the `new TBrowser` on root command.

#### Important variables

| Type        | Name                 | Purpose  |
|-------------|----------------------|----------|
| string      | MuonId               | It accepts values of `"trackerMuon"`, `"standaloneMuon"` and `"globalMuon"` |
| string      | xquantity            | It accepts values of `"Pt"`, `"Eta"` and `"Phi"` for horizontal axis |
| double[]    | xbins                | is used to set histogram bins limits for horizontal axis |
| string      | yquantity            | It accepts values of `"Pt"`, `"Eta"` and `"Phi"` for vertical axis |
| double[]    | ybins                | is used to set histogram bins limits for vertical axis |
| string      | path_bins_fit_folder | Stores the path folder where is going to save fit results png for every bin  |
| const char* | output_folder_name   | Stores the path to output folder where is going to save the 2D efficiency result |
