# class PtEtaPhi

Holds [PassingFailing class](PassingFailing.md).

### Constructor details

```cpp
PtEtaPhi(
    const char*& resonance,
    const char*& particleName,
    const char*& canvasWatermark,
    const char*& directoryToSave,
    const char*& particleType,
    InvariantMass& ObjMass,
    const char*& tagOrProbe,
    const char*  quantityName,
    const char*  xAxisName,
    const char*  quantityUnit,
    const char*  extendedQuantityName,
    int          nBins,
    double       xMin,
    double       xMax,
    int          decimals = 3)
      : resonance(resonance),
        particleName(particleName),
        canvasWatermark(canvasWatermark),
        directoryToSave(directoryToSave),
        particleType(particleType),
        ObjMass(ObjMass),
        tagOrProbe(tagOrProbe),
        quantityName(quantityName),
        xAxisName(xAxisName),
        quantityUnit(quantityUnit),
        extendedQuantityName(extendedQuantityName),
        nBins(nBins),
        xMin(xMin),
        xMax(xMax),
        decimals(decimals)
{}
```

### Private variable details

Summary

| Type           | Name            |
|----------------|-----------------|
| const char*&   | resonance       |
| const char*&   | particleName    |
| const char*&   | canvasWatermark |
| const char*&   | directoryToSave |
| const char*&   | particleType    |
| const char*&   | tagOrProbe      |
| InvariantMass& | ObjMass         |

<br>
All variables here are reference for public variables in mother class: [TagProbe class](TagProbe.md).

### Public variable details

Summary

| Type         | Name                 | Default value |
|--------------|----------------------|---------------|
| const char*  | tagOrProbe           | NULL          |
| const char*  | xAxisName            | NULL          |
| const char*  | quantityUnit         | NULL          |
| const char*  | extendedQuantityName | NULL          |
| double       | xMin                 | 0.            |
| double       | xMax                 | 0.            |
| int          | nBins                | 0             |
| int          | decimals             | 3             |
| TEfficiency* | pEff                 | NULL          |

<br>
Details

* `const char* quantityName`
    * Stores the quantity name. E.g.: "pT".
* `const char* extendedQuantityName`
    * Stores the extended quantity name. E.g.: "Transversal Momentum".
* `const char* quantityUnit`
    * Stores the quantity unit. E.g.: "GeV/c".
* `const char* xAxisName`
    * Stores the quantity name for histogram horizontal axis in LaTeX form. E.g.: "p_{t}".
* `int nBins`
    * Stores the number of bins in histograms.
* `int decimals = 3`
    * Number of decimals showed in bin width on histogram vertical axis.
* `double xMin`
    * Lower horizontal value of histogram.
* `double xMax`
    * Higher horizontal value of histogram.
* `TEfficiency* pEff`
    * Stores the efficiency plot.

Constructed objects

* `PassingFailing Pass`
    * Stores all informations about invariant masses, including fit and histograms.
* `PassingFailing All`
    * Stores all informations about tag muons, incuding quantities histograms and efficiencies.

### Public Functions details

#### consistencyDebugCout()

```cpp
void consistencyDebugCout()
```

Print on terminal the consistency check after subtractSigHistograms().

#### createEfficiencyCanvas(...)

```cpp
void createEfficiencyCanvas(bool shouldWrite = false,
                            bool shouldSavePNG = false)
```

Create canvas for all efficiencies calculated. It need to be called after createEfficiencyPlot(...).

#### createEfficiencyPlot(...)

```cpp
TEfficiency* createEfficiencyPlot(bool shouldWrite = false)
```

Create a TEfficiency object with calculated efficiency. It needs do be called after subtractSigHistograms().

#### createQuantitiesCanvas(...)

```cpp
TCanvas* createQuantitiesCanvas(bool shouldWrite = false,
                            bool shouldSavePNG = false)
```

Create canvas for all quantities after subtractSigHistograms().

#### fillQuantitiesHistograms(...)

```cpp
void fillQuantitiesHistograms(double& quantity,
                            double& InvariantMass,
                            int& isPassing)
```

Automatically fill all quantities histograms. Needs to be called in a loop over all dataset.

#### normalizeHistograms()

```cpp
void normalizeHistograms()
```

Normalize quantities histograms of variable bin after filling it.

#### subtractSigHistograms()

```cpp
void subtractSigHistograms()
```

Apply sideband subtraction over all histograms.

#### writeQuantitiesHistogramsOnFile(...)

```cpp
void writeQuantitiesHistogramsOnFile(bool hSigBack,
                                    bool hSig,
                                    bool hBack)
```

Write all quantities histograms in a root file. Just need to call this function and all quantities histograms will be written. It needs to be called after subtractSigHistograms().