# The Macro

A macro is a code file create to be interpreted by a program. In this case, ROOT program will interpret it. The main code of this tool is in the file `macro.ccp`. In this section what compose this file is explained in details.

## About the code

`macro.cpp` is a example how to use Sideband Subtraction to get reconstruction efficiencies for a *Tag & Probe* ntupple. It analyzes **J/psi** and **Upsilon** reconstruction efficiency for **tracker**, **standalone** and **global** muons. The file is encountered in folder `main`. Now, I going to talk about what this function do and how it does in the text below.

!!! Dataset used
    The datasets used in this code are obtained with the main code of this Tag an Probe tool.

## Classes list

There are some classes in Sideband Subtraction Tag And Probe project and they are distributed in these files with same name:

**Static functions**:

* [FitFunctions](FitFunctions.md)
    * [Primary](FitFunctions.md#primary)
    * [Merged](FitFunctions.md#merged)
        * Jpsi
        * Upsilon

**Classes and struct**:

* [SidebandSubtraction](SidebandSubtraction.md)
    * [Type](Type.md)
        * [InvariantMass](InvariantMass.md)
            * [MassValues](MassValues.md)
        * [TagProbe](TagProbe.md)
            * [PtEtaPhi](PtEtaPhi.md)
                * [PassingFailing](PassingFailing.md)

This format shows what nested classes. Classes or structs below slided at right represents they are nested with the class above it.

## Sideband Subtraction code structure

The diagram below represents the structure of objects in code. At left we have the structure of objects name. At right we have the correspondent class name of objects in these line.

![Main class structure](../../../../images/analysis/cmsefficiency/main_structure.png)

Also in Mass object we have:

![Mass class structure](../../../../images/analysis/cmsefficiency/mass_structure.png)

Notice that all objects in same line shares the same structure.

## Before macro.cpp

There are some files in folder `config` aside of `macro.ccp`. The sections below explain about them.

### cuts.h

---

This is it content:

```cpp
//This files holds some functions used in macro.cpp for particle selection

//Return if is a accepted particle or no
bool applyCuts(double** quantities, int** types)
{
    //Assign variables for easy visualization
    double &ProbeMuon_Pt            = *quantities[0];
    double &ProbeMuon_Eta           = *quantities[1];
    double &ProbeMuon_Phi           = *quantities[2];
    double &TagMuon_Pt              = *quantities[3];
    double &TagMuon_Eta             = *quantities[4];
    double &TagMuon_Phi             = *quantities[5];
    double &InvariantMass           = *quantities[6];
    int &PassingProbeTrackingMuon   = *types[0];
    int &PassingProbeStandAloneMuon = *types[1];
    int &PassingProbeGlobalMuon     = *types[2];

    //Apply cuts
    if (TagMuon_Pt >= 7.0 && fabs(TagMuon_Eta) <= 2.4)
        return true;

    return false;
}
```

It stores the function applyCuts(), where return `true` for allowed pair of particles and `false` for not allowed.

---

### createHistogram.h

---

This file is called in PassingFailing.cpp and set quantity histograms bins and create the hitogram. Its default content is shwon bellow:

```cpp
void createHistogram(TH1D* &histo, const char* histoName)
{
    //Set parameters
    string hName          = string(particleType) + string(passingOrFailing) + string(tagOrProbe) + string(particleName) + "_" + string(quantityName) + string(histoName);
    string hTitle         = string(passingOrFailing) + " in " + string(particleType) + " " + string(tagOrProbe);
    string xAxisTitle     = string(xAxisName);
    string yAxisTitleForm = "Events";

    //Add unit if has
    if (strcmp(quantityUnit, "") != 0)
        xAxisTitle += " [" + string(quantityUnit) + "]";

    //Change title is passing
    if (strcmp(passingOrFailing, "Passing") == 0)
        hTitle = string(particleType) + " " + string(particleName) + " " + string(tagOrProbe);

    if (strcmp(passingOrFailing, "All") == 0)
        hTitle = "All " + string(particleName) + " " + string(tagOrProbe);


    //Variable bin for pT
    if (strcmp(quantityName, "Pt") == 0)
    {
        double xbins[] = {0., 2.0, 3.4, 4.0, 4.4, 4.7, 5.0, 5.6, 5.8, 6.0, 6.2, 6.4, 6.6, 6.8, 7.3, 9.5, 13.0, 17.0, 40.};
        
        int nbins = sizeof(xbins)/sizeof(*xbins) - 1;
        histo = new TH1D(hName.data(), hTitle.data(), nbins, xbins);
    }

    //Variable bin for eta
    else if (strcmp(quantityName, "Eta") == 0)
    {
        double xbins[] = {-2.4, -1.8, -1.4, -1.2, -1.0, -0.8, -0.5, -0.2, 0, 0.2, 0.5, 0.8, 1.0, 1.2, 1.4, 1.8, 2.4};
        
        int nbins = sizeof(xbins)/sizeof(*xbins) - 1;
        histo = new TH1D(hName.data(), hTitle.data(), nbins, xbins);
    }

    //Bins for phi 
    else
    {
        double xbins[] = {-3.0, -1.8, -1.6, -1.2, -1.0, -0.7, -0.4, -0.2, 0, 0.2, 0.4, 0.7, 1.0, 1.2, 1.6, 1.8, 3.0};
        
        int nbins = sizeof(xbins)/sizeof(*xbins) - 1;
        histo = new TH1D(hName.data(), hTitle.data(), nbins, xbins);
    }

    //Edit histogram axis
    histo->GetYaxis()->SetTitle(Form(yAxisTitleForm.data(), histo->GetBinWidth(0)));
    histo->GetXaxis()->SetTitle(xAxisTitle.data());
}
```

---

### settings.cpp

---

It stores many configurations used in `macro.cpp`:

```cpp
//List of files
const char *files[] = {"../data_histoall.root",
                        "../Run2011AMuOnia_mergeNtuple.root",
                        "../JPsiToMuMu_mergeMCNtuple.root",
                        "../Run2011A_MuOnia_Upsilon.root",
                        "../Upsilon1SToMuMu_MC_full.root"};

const char* directoriesToSave[] = {"../results/result/",
                                    "../results/Jpsi_Run_2011/",
                                    "../results/Jpsi_MC_2020_sbs/",
                                    "../results/Upsilon_Run_2011/",
                                    "../results/Upsilon_MC_2020_sbs/"};

//MAIN OPTIONS

//Which file of files (variable above) should use
int useFile = 4;

//Set the canvasW wtermark
const char* canvasWatermark = "#bf{CMS Open Data}";

//Path where is going to save results 
const char* directoryToSave = directoriesToSave[useFile];
//directoryToSave = "../result/";

//Should limit data?
long long limitData = 0; //0 -> do not limit

//Canvas drawing
bool shouldDrawInvariantMassCanvas          = true;
bool shouldDrawInvariantMassCanvasRegion    = true;
bool shouldDrawQuantitiesCanvas             = true;
bool shouldDrawEfficiencyCanvas             = true;

//Muon id anlyse
bool doTracker    = true;
bool doStandalone = false;
bool doGlobal     = false;

//Muon label anlyse
bool doTagMuon   = false;
bool doProbeMuon = true;

//ENDED MAIN OPTIONS
```

---

And then there are more automatically set options:

```cpp
//Auto detect resonance due file index
const char* resonance = "Jpsi";
if (useFile > 2)
    resonance = "Upsilon";
if (useFile == 4)
    resonance = "Upsilon1S";



//Auto detect limit of data
if (limitData > 0)
    directoryToSave = "../partial_result/";



//Compatibility adjusts on file read (for data_histoall ntupples)
bool needsRetroCompatibility = false;

if (useFile == 0)
    needsRetroCompatibility = true;
```

---

## Code explained in parts

---

`macro.cpp` is the main file of this program. Its the main code. It is explained in parts below:

```cpp
//Input files, options are set here!
#include "config/settings.cpp"
```

It imports configurations about macro.cpp

---

```cpp
//Check if the name of dir is ok
if (string(directoryToSave).back() != string("/"))
{
    cerr << "To avoid errors, please end the result directory with a \"/\"" << endl;
    abort();
}

//Check if dir exists and create
if (gSystem->AccessPathName(directoryToSave))
{
    if (gSystem->mkdir(directoryToSave, true))
    {
        cerr << "\"" << directoryToSave << "\" path could not be found and could not be created ERROR" << endl;
        cerr << "Try to create manually this folder path" << endl;
        abort();
    }
    else
    {
        cout << "\"" << directoryToSave << "\" directory created OK" << endl;
    }
}
else
{
    cout << "\"" << directoryToSave << "\" directory OK" << endl;
}
```

Check if the `directoryToSave` (setted in settings.cpp) has a valid name and if exists. If not, the code creates the folder.

---

```cpp
//Compatibility adjusts on file read (for data_histoall ntupples)
string folderName = "tagandprobe/";
if (needsRetroCompatibility)
    folderName = "demo/";

//Open and read files
TFile *file0  = TFile::Open(files[useFile]);
TTree *TreePC = (TTree*)file0->Get((folderName + "PlotControl").data());
TTree *TreeAT = (TTree*)file0->Get((folderName + "AnalysisTree").data());
cout << "Using \"" << files[useFile] << "\" ntupple" << endl;
```

This part is responsible to open the file and do conversions. The first one file is a bit different of the other ones, so it needs compatibiliy besides its not important anymore and is a obsolete file.

---

```cpp
//Create variables
double ProbeMuon_Pt;
double ProbeMuon_Eta;
double ProbeMuon_Phi;
double TagMuon_Pt;
double TagMuon_Eta;
double TagMuon_Phi;
double InvariantMass;
int PassingProbeTrackingMuon;
int PassingProbeStandAloneMuon;
int PassingProbeGlobalMuon;

//Assign variables
TreePC->SetBranchAddress("ProbeMuon_Pt",                &ProbeMuon_Pt);
TreePC->SetBranchAddress("ProbeMuon_Eta",               &ProbeMuon_Eta);
TreePC->SetBranchAddress("ProbeMuon_Phi",               &ProbeMuon_Phi);
TreePC->SetBranchAddress("TagMuon_Pt",                  &TagMuon_Pt);
TreePC->SetBranchAddress("TagMuon_Eta",                 &TagMuon_Eta);
TreePC->SetBranchAddress("TagMuon_Phi",                 &TagMuon_Phi);
if (needsRetroCompatibility)
TreePC->SetBranchAddress("InvariantMass",               &InvariantMass);
else
TreeAT->SetBranchAddress("InvariantMass",               &InvariantMass);
TreeAT->SetBranchAddress("PassingProbeTrackingMuon",    &PassingProbeTrackingMuon);
TreeAT->SetBranchAddress("PassingProbeStandAloneMuon",  &PassingProbeStandAloneMuon);
TreeAT->SetBranchAddress("PassingProbeGlobalMuon",      &PassingProbeGlobalMuon);

double* quantities[] = {&ProbeMuon_Pt,
                        &ProbeMuon_Eta,
                        &ProbeMuon_Phi,
                        &TagMuon_Pt,
                        &TagMuon_Eta,
                        &TagMuon_Phi,
                        &InvariantMass,
    };

int* types[] = {&PassingProbeTrackingMuon,
                &PassingProbeStandAloneMuon,
                &PassingProbeGlobalMuon
    };
```

Now variables are created and linked to branches in ntupple. Then a array of these variables are set.

---

```cpp
//Create a object and set configs
SidebandSubtraction SdS{resonance};
SdS.canvasWatermark = canvasWatermark;
SdS.directoryToSave = directoryToSave;
SdS.doTracker       = doTracker;
SdS.doStandalone    = doStandalone;
SdS.doGlobal        = doGlobal;
SdS.doTagMuon       = doTagMuon;
SdS.doProbeMuon     = doProbeMuon;

cout << "resonance: " << SdS.resonance << "\n";
cout << "Using subtraction factor as integral of background fit\n";
```

The macro.cpp now creates the SdS object and assign variables setted in settings.cpp. At this point, it creates all histograms that you will need such as invariant mass histograms and pT, eta, phi histograms.

---

```cpp
//Get data size and set data limit if has
long long numberEntries = TreePC->GetEntries();
if (limitData > 0 && limitData < numberEntries)
    numberEntries = limitData;
printf("Data analysed = %lld of %lld\n", numberEntries, TreePC->GetEntries());

//Prepare for showing progress
string progressFormat = "Progress: %05.2f%% %0"+to_string(strlen(to_string(numberEntries).data()))+"lld/%lld\r";
auto lastTime = std::chrono::steady_clock::now();
auto start    = std::chrono::steady_clock::now();
```

Now the code are limiting data if you setted and setting a string for progress information while filling histograms.

---

```cpp
cout << "\nFilling Invariant Mass Histograms..... (1/2)\n";

//Loop between the components
for (long long i = 0; i < numberEntries; i++)
{
    //Select particle pair
    TreePC->GetEntry(i);
    TreeAT->GetEntry(i);

    //Show progress on screen
    if (chrono::duration_cast<chrono::milliseconds>(chrono::steady_clock::now() - lastTime).count() >= 1000 || i == numberEntries - 1)
    {
        printf(progressFormat.data(), (float)(i+1)/(float)numberEntries*100, i+1, numberEntries);
        lastTime = chrono::steady_clock::now();
    }

    //Fill histograms
    if (applyCuts(quantities, types))
    {
        SdS.fillMassHistograms(quantities, types);
    }
}

cout << "\nTook " << chrono::duration_cast<chrono::milliseconds>(chrono::steady_clock::now() - start).count() << " ms\n";
```

This part of the code fill invariant mass histograms. Cuts are applyied in cuts.h.
At this point, macro.cpp separes in passing and all muons.

---

```cpp
//Do function fit over the histogram
SdS.doFit();

//Get values for invariant mass and sigma from plot
SdS.updateMassValuesAll();
```

After filling mass histograms, it is necessary to apply the fit function.

After doing fit, *updateMassValuesAll()* get regions for sideband subtraction mostly based in fitting.

---

```cpp
//-------------------------------------
// Generate and save files
//-------------------------------------

//Create file root to store generated files
TFile* generatedFile = TFile::Open((string(directoryToSave) + "generated_hist.root").data(),"RECREATE");
generatedFile->mkdir("canvas/");
generatedFile->   cd("canvas/");

if (shouldDrawInvariantMassCanvas)
{
    bool drawRegions    = false;
    bool shouldWrite    = true;
    bool shouldSavePNG  = true;

    SdS.createMassCanvas(drawRegions, shouldWrite, shouldSavePNG);
}

if (shouldDrawInvariantMassCanvasRegion && !isMC)
{
    bool drawRegions    = true;
    bool shouldWrite    = true;
    bool shouldSavePNG  = true;

    SdS.createMassCanvas(drawRegions, shouldWrite, shouldSavePNG);
}
```

Canvas are drawn and saved in the `generated_hist.root` file and in the folder as `.png`.

---

```cpp
//Prepare for showing progress
lastTime = std::chrono::steady_clock::now();
start    = std::chrono::steady_clock::now();

cout << "\nFilling Quantities Histograms..... (2/2)\n";

//Loop between the components again
for (long long i = 0; i < numberEntries; i++)
{
    //Select particle pair
    TreePC->GetEntry(i);
    TreeAT->GetEntry(i);

    //Show progress on screen
    if (chrono::duration_cast<chrono::milliseconds>(chrono::steady_clock::now() - lastTime).count() >= 1000 || i == numberEntries - 1)
    {
        printf(progressFormat.data(), (float)(i+1)/(float)numberEntries*100, i+1, numberEntries);
        lastTime = chrono::steady_clock::now();
    }

    //Fill histograms
    if (applyCuts(quantities, types))
    {   
        SdS.fillQuantitiesHistograms(quantities, types);
    }
}
cout << "\nTook " << chrono::duration_cast<chrono::milliseconds>(chrono::steady_clock::now() - start).count() << " ms\n";
```

At this point of the code, this will separate all histogram in signal + background (signal region) and background (sideband region) due the regions for sideband choosen before.

---

```cpp
//Normalize Histograms for variable binning
cout << "\n";
SdS.normalizeHistograms();  
```

After folling histograms, as some of them has variable bins, it needs to be normalized. This function does this.

---

```cpp
//For sideband subtraction
SdS.subtractSigHistograms();
```

Subtract `background` from `signal + background` histogram to create signal histogram. This method is what is called *sideband subtraction*.

---

```cpp
if (shouldDrawQuantitiesCanvas)
{
    bool shouldWrite    = true;
    bool shouldSavePNG  = true;

    cout << endl;
    SdS.createQuantitiesCanvas(shouldWrite, shouldSavePNG);
}
```

The code here draw the canvas for all pT, eta and phi quantities it has. Including `background`, `signal` and `signal + background`.

---

```cpp
//Debug consistency for histograms
SdS.consistencyDebugCout();
```

This is a checker of how consistent is our result values and print on terminal results. For all histograms this calculations should result 0. For more details about how exactly it works, see [consistencyDebugCout()](PassingFailing.md#consistencydebugcout).

---

```cpp
//Save histograms
generatedFile->mkdir("histograms/");
generatedFile->   cd("histograms/");

//Write quantities histograms on file
{
    bool writehSigBack  = true;
    bool writehSig      = true;
    bool writehBack     = true;

    SdS.writeQuantitiesHistogramsOnFile(writehSigBack, writehSig, writehBack);
}

//Write mass histograms on file
{
    bool writehPass = true;
    bool writehAll  = true;

    SdS.writeMassHistogramsOnFile(writehPass, writehAll);
}
```

At this point, the code will write all histograms in a folder in the `.root` generated file. Including mass histograms and quantities histograms.

---

```cpp
//Save plots
generatedFile->mkdir("efficiency/plots/");
generatedFile->cd("efficiency/plots/");

//Creates efficiency plots
{
    bool shouldWrite    = true;

    SdS.createEfficiencyPlot(shouldWrite);
}
```

It calculates the efficiency of the quantities by using [TEfficiency](https://root.cern.ch/doc/master/classTEfficiency.html) class of ROOT. Then saves the plots in another folder inside the `.root` file.

---

```cpp
//Saves new histograms and canvas in file
generatedFile->mkdir("efficiency/canvas/");
generatedFile->cd("efficiency/canvas/");

if (shouldDrawEfficiencyCanvas)
{
    bool shouldWrite    = true;
    bool shouldSavePNG  = true;

    cout << "\n";
    SdS.createEfficiencyCanvas(shouldWrite, shouldSavePNG);
}

//Close files
generatedFile->Close();

cout << "\nDone. All result files can be found at \"" << SdS.directoryToSave << "\"\n\n";
```

The end point of this function. It creates a canvas for every efficiency plot calculated above and also saves in the generated file. After this, the task is done.

---

## Results

All results are saved in a folder setted in `directoryToSave` variable. The result contains a file `.root` with all canvas, histograms and plots aside of `.png` images of all canvas created.
