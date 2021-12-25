# class TagProbe

Holds [TagProbe class](TagProbe.md) and [InvariantMass class](InvariantMass.md).

## Constructor details

```cpp
TagProbe(
    const char*& resonance,
    const char*& particleName,
    const char*& canvasWatermark,
    const char*& directoryToSave,
    const char*& particleType,
    InvariantMass& ObjMass,
    const char*  tagOrProbe)
      : resonance(resonance),
        particleName(particleName),
        canvasWatermark(canvasWatermark),
        directoryToSave(directoryToSave),
        particleType(particleType),
        ObjMass(ObjMass),
        tagOrProbe(tagOrProbe)
{}
```

## Private variable details

Summary

| Type           | Name            |
|----------------|-----------------|
| const char*&   | resonance       |
| const char*&   | particleName    |
| const char*&   | canvasWatermark |
| const char*&   | directoryToSave |
| const char*&   | particleType    |
| InvariantMass& | ObjMass         |

All variables here are reference for public variables in mother class: [Type class](Type.md)

## Public variable details

Summary

| Type        | Name         | Default value |
|-------------|--------------|---------------|
| const char* | tagOrProbe   | NULL          |

Details

* `const char* tagOrProbe = NULL`
    * Set if it is "Tag" or "Probe" object

Constructed objects

* `PtEtaPhi Pt`
    * Transversal momentum histograms.
* `PtEtaPhi Eta`
    * Pseudorapidity histograms.
* `PtEtaPhi Phi`
    * Azimutal angle histograms.

## Public Functions details

### consistencyDebugCout()

```cpp
void consistencyDebugCout()
```

Print on terminal the consistency check after subtractSigHistograms().

### createEfficiencyCanvas(...)

```cpp
void createEfficiencyCanvas(bool shouldWrite = false,
                            bool shouldSavePNG = false)
```

Create canvas for all efficiencies calculated. It need to be called after createEfficiencyPlot(...).

### createEfficiencyPlot(...)

```cpp
void createEfficiencyPlot(bool shouldWrite = false)
```

Create a TEfficiency object with calculated efficiency. It needs do be called after subtractSigHistograms().

### createQuantitiesCanvas(...)

```cpp
void createQuantitiesCanvas(bool shouldWrite = false,
                            bool shouldSavePNG = false)
```

Create canvas for all quantities after subtractSigHistograms().

### fillQuantitiesHistograms(...)

```cpp
void fillQuantitiesHistograms(double** quantities,
                            double& InvariantMass,
                            int& isPassing)
```

Automatically fill all quantities histograms. Needs to be called in a loop over all dataset.

### normalizeHistograms()

```cpp
void normalizeHistograms()
```

Normalize quantities histograms of variable bin after filling it.

### subtractSigHistograms()

```cpp
void subtractSigHistograms()
```

Apply sideband subtraction over all histograms.

### writeQuantitiesHistogramsOnFile(...)

```cpp
void writeQuantitiesHistogramsOnFile(bool hSigBack,
                                    bool hSig,
                                    bool hBack)
```

Write all quantities histograms in a root file. Just need to call this function and all quantities histograms will be written. It needs to be called after subtractSigHistograms().
