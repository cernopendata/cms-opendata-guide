# class InvariantMass

Holds [MassValues struct](MassValues.md).

### Constructor details

```cpp
InvariantMass(
    const char*& resonance,
    const char*& particleName,
    const char*& canvasWatermark,
    const char*& directoryToSave,
    const char*& particleType)
      : resonance(resonance),
        particleName(particleName),
        canvasWatermark(canvasWatermark),
        directoryToSave(directoryToSave),
        particleType(particleType)
{
    if (strcmp(resonance, "Jpsi") == 0)
    {
        xMin  = 2.9;
        xMax  = 3.3;
        nBins = 160;
    }

    if (strcmp(resonance, "Upsilon") == 0)
    {
        xMin  = 8.7;
        xMax  = 11.;
        nBins = 60;
    }

    if (strcmp(resonance, "Upsilon1S") == 0)
    {
        xMin  = 8.7;
        xMax  = 11.;
        nBins = 60;
    }

    createMassHistogram(Pass.hMass, "Passing");
    createMassHistogram(All. hMass, "All");
}
```

### Private variable details

Summary

| Type           | Name                 |
|----------------|----------------------|
| const char*&   | resonance            |
| const char*&   | particleName         |
| const char*&   | canvasWatermark      |
| const char*&   | directoryToSave      |
| const char*&   | particleType         |

<br>
All variables here are reference for public variables in mother class: [Type class](Type.md)

### Private Functions details

#### createMassHistogram(...)

```cpp
void createMassHistogram(TH1D* &hMass,
                        const char* PassingOrFailing)
```

Create invariant mass histogram with a specific title. The argument `hMass` is a pointer where the histogram shall be stored.

#### drawCanvasQuarter(...)

```cpp
void drawCanvasQuarter(TCanvas* &canvas,
                    bool drawRegions,
                    int quarter,
                    MassValues* ObjMassValues,
                    int color = kBlue)
```

Draw a quarter of whole canvas with invariant mass histogram pointed.

### Public variable details

Summary

| Type         | Name                 | Default value |
|--------------|----------------------|---------------|
| double       | xMin                 | 0.            |
| double       | xMax                 | 0.            |
| int          | nBins                | 0             |
| int          | decimals             | 3             |

<br>

Constructed objects

* `MassValues Pass`
    * Stores information about passing mass histograms.
* `MassValues All`
    * Stores information about passing mass histograms.

### Public Functions details

#### createMassCanvas(...)

```cpp
TCanvas* createMassCanvas(bool drawRegions = false,
                        bool shouldWrite = false,
                        bool shouldSavePNG = false)
```

Create canvas for invariant mass (passing and all muons).

#### defineMassHistogramNumbers()

```cpp
void defineMassHistogramNumbers(int nBins,
                                double xMin,
                                double xMax,
                                int decimals = 3)
```

Redefine number parameters of mass histograms in Mass object.

#### doFit()

```cpp
void doFit()
```

Apply a fit over invariant mass in MassValues objects.

#### fillMassHistograms(...)

```cpp
void fillMassHistograms(double** quantities,
                        int** types)
```

Automatically fill masses histograms. Needs to be called in a loop over all dataset.

#### updateMassValuesAll()

```cpp
void updateMassValuesAll()
```

After fill invariant mass histogram, you need to set signal regions and sideband regions. This function will set it for you.

#### updateMassValuesAll(...)

```cpp
void updateMassValuesFor(MassValues* ObjMassValues,
                        bool isAll = false)
```

After fill invariant mass histograms, you need to set signal regions and sideband regions. This function will set it for you.

#### writeMassHistogramsOnFile(...)

```cpp
void writeMassHistogramsOnFile(bool writehPass,
                            bool writehAll)
```

Write all mass canvas histograms in a root file. Just need to call this function and all mass histograms will be written.