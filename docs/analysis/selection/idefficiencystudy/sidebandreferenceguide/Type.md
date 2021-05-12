# class Type

Holds [TagProbe class](TagProbe.md) and [InvariantMass class](InvariantMass.md).

### Constructor details

```cpp
	Type(
		const char*& resonance,
		const char*& particleName,
		bool& doTagMuon,
		bool& doProbeMuon,
		const char*& canvasWatermark,
		const char*& directoryToSave,
	 	const char*  particleType)
		  : resonance(resonance),
		    particleName(particleName),
		    doTagMuon(doTagMuon),
		    doProbeMuon(doProbeMuon),
		    canvasWatermark(canvasWatermark),
		    directoryToSave(directoryToSave),
		    particleType(particleType)
	{}
```

### Private variable details

Summary

| Type         | Name            |
|--------------|-----------------|
| const char*& | resonance       |
| const char*& | particleName    |
| bool&        | doTagMuon       |
| bool&        | doProbeMuon     |
| const char*& | canvasWatermark |
| const char*& | directoryToSave |

<br>
All variables here are reference for public variables in mother class: [SidebandSubtraction class](SidebandSubtraction.md).

### Public variable details

Summary

| Type        | Name         | Default value |
|-------------|--------------|---------------|
| const char* | particleType | NULL          |

<br>
Details

* `const char* particleType = NULL`
	* Set the name of particle type.

Constructed objects

* `InvariantMass Mass`
	* Stores all informations about invariant masses, including fit and histograms.
* `TagProbe Tag`
	* Stores all informations about tag muons, incuding quantities histograms and efficiencies.
* `TagProbe Probe`
	* Stores all informations about probe muons, incuding quantities histograms and efficiencies.

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
void createEfficiencyPlot(bool shouldWrite = false)
```

Create a TEfficiency object with calculated efficiency. It needs do be called after subtractSigHistograms().

#### createMassCanvas(...)

```cpp
void createMassCanvas(bool drawRegions = false,
					bool shouldWrite = false,
					bool shouldSavePNG = false)
```

Create canvas for all invariant mass (passing and all muons).

#### createQuantitiesCanvas(...)

```cpp
void createQuantitiesCanvas(bool shouldWrite = false,
							bool shouldSavePNG = false)
```

Create canvas for all quantities after subtractSigHistograms().

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

Apply a fit over invariant mass in Mass object.

#### fillMassHistograms(...)

```cpp
void fillMassHistograms(double& InvariantMass,
						int& isPassing)
```

Automatically fill all masses histograms. Needs to be called in a loop over all dataset.

#### fillQuantitiesHistograms(...)

```cpp
void fillQuantitiesHistograms(double** quantities,
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

#### updateMassValuesAll()

```cpp
void updateMassValuesAll()
```

After fill invariant mass histograms, you need to set signal regions and sideband regions. This function will set it for you.

#### writeMassHistogramsOnFile(...)

```cpp
void writeMassHistogramsOnFile(bool writehPass,
							bool writehAll)
```

Write all mass canvas histograms in a root file. Just need to call this function and all mass histograms will be written.

#### writeQuantitiesHistogramsOnFile(...)

```cpp
void writeQuantitiesHistogramsOnFile(bool hSigBack,
									bool hSig,
									bool hBack)
```

Write all quantities histograms in a root file. Just need to call this function and all quantities histograms will be written. It needs to be called after subtractSigHistograms().