# class PassingFailing

Holds histograms of passing and all particle quantities.

## Constructor details

```cpp
PassingFailing(
    const char*& resonance,
    const char*& particleName,
    const char*& canvasWatermark,
    const char*& directoryToSave,
    const char*& particleType,
    InvariantMass& ObjMass,
    const char*& tagOrProbe,
    const char*  passingOrFailing,
    const char*& quantityName,
    const char*& xAxisName,
    const char*& quantityUnit,
    const char*& extendedQuantityName,
    double&      xMin,
    double&      xMax,
    int&         nBins,
    int&         decimals)
      : resonance(resonance),
        particleName(particleName),
        canvasWatermark(canvasWatermark),
        directoryToSave(directoryToSave),
        particleType(particleType),
        ObjMass(ObjMass),
        tagOrProbe(tagOrProbe),
        passingOrFailing(passingOrFailing),
        quantityName(quantityName),
        xAxisName(xAxisName),
        quantityUnit(quantityUnit),
        extendedQuantityName(extendedQuantityName),
        nBins(nBins),
        xMin(xMin),
        xMax(xMax),
        decimals(decimals)
{
    createHistogram(hSigBack, "SigBack");
    createHistogram(hSig,     "Sig");
    createHistogram(hBack,    "Back");
}
```

## Private variable details

Summary

| Type           | Name                 |
|----------------|----------------------|
| const char*&   | resonance            |
| const char*&   | particleName         |
| const char*&   | canvasWatermark      |
| const char*&   | directoryToSave      |
| const char*&   | particleType         |
| const char*&   | tagOrProbe           |
| InvariantMass& | ObjMass              |
| const char*&   | tagOrProbe           |
| const char*&   | xAxisName            |
| const char*&   | quantityUnit         |
| const char*&   | extendedQuantityName |
| double&        | xMin                 |
| double&        | xMax                 |
| int&           | nBins                |
| int&           | decimals             |

All variables here are reference for public variables in mother class: [PtEtaPhi class](PtEtaPhi.md).

## Private Functions details

### createHistogram()

```cpp
void createHistogram()
```

Create quantity histogram.

### fillAfter()

```cpp
string fillAfter(string text,
                char fillWith,
                int targetLength)
```

Fill blank space of a string. It is used in consistencyDebugCout().

## Public variable details

Summary

| Type         | Name                 | Default value |
|--------------|----------------------|---------------|
| const char*  | passingOrFailing     | NULL          |
| TH1D*        | hSigBack             | NULL          |
| TH1D*        | hSig                 | NULL          |
| TH1D*        | hBack                | NULL          |

Details

* `const char* passingOrFailing`
    * Set if it is "Passing" or "All" object.
* `TH1D* hSigBack`
    * Stores the histogram for particles in signal region.
* `TH1D* hSig`
    * Stores the subtracted histogram.
* `TH1D* hBack`
    * Stores the histogram for particles in sideband region.

## Public Functions details

### consistencyDebugCout()

```cpp
void consistencyDebugCout()
```

Print on terminal the consistency check after subtractSigHistogram().

It is result for this equation:

![N_{total} - (\alpha N_{background} + N_{signal})](../../../../images/analysis/cmsefficiency/sidebandreferenceguide/consistencyDebugCout.svg)

Where: alpha = yield of background particles signal region / yield of background particles sideband region

### createQuantitiesCanvas(...)

```cpp
TCanvas* createQuantitiesCanvas(bool shouldWrite = false,
                            bool shouldSavePNG = false)
```

Create canvas for all quantities after subtractSigHistograms().

### fillQuantitiesHistograms(...)

```cpp
void fillQuantitiesHistograms(double& InvariantMass,
                            int& isPassing)
```

Automatically fill all quantities histograms. Needs to be called in a loop over all dataset.

### normalizeHistograms()

```cpp
void normalizeHistograms()
```

Normalize quantities histograms of variable bin after filling it.

### PassFailObj()

```cpp
MassValues* PassFailObj()
```

Get the MassValue object of corresponding MassValue object.

### subtractSigHistogram()

```cpp
void subtractSigHistogram()
```

Apply sideband subtraction over histograms.

### writeQuantitiesHistogramsOnFile(...)

```cpp
void writeQuantitiesHistogramsOnFile(bool hSigBack,
                                    bool hSig,
                                    bool hBack)
```

Write quantity histograms in a root file. Just need to call this function and all quantities histograms will be written. It needs to be called after subtractSigHistograms().
