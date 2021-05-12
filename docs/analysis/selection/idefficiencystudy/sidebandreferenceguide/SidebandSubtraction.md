# class SidebandSubtraction

Holds [Type class](Type.md). This is the mother class.

### Constructor details

```cpp
SidebandSubtraction()
{}
```

```cpp
SidebandSubtraction(const char* resonance)
		: resonance(resonance)
{}
```

### Public variable details

Summary

| Type       | Name            | Default value       |
|------------|-----------------|---------------------|
|const char* | resonance       | "Jpsi"              |
|const char* | particleName    | "Muon"              |
|const char* | canvasWatermark | "#bf{CMS Open Data}"|
|const char* | directoryToSave | "../result/"        |
|bool        | doTracker       | true                |
|bool        | doStandalone    | true                |
|bool        | doGlobal        | true                |
|bool        | doTagMuon       | true                |
|bool        | doProbeMuon     | true                |

<br>
Details

* `const char* resonance = "Jpsi"` 
	* Supports values `"Jpsi"`, `"Upsilon"` or `"Upsilon(1S)"`.
* `const char* particleName = "Muon"`
	* Stores the particle name for titles.
* `const char* canvasWatermark = "#bf{CMS Open Data}"`
	* Stores what watermark will be showed in plots.
* `const char* directoryToSave = "../result/"`
	* Where all canvas will be stored.
* `bool doTracker    = true`
	* If it will compute Tracker muons efficiency.
* `bool doStandalone = true`
	* If it will compute Standalone muons efficiency.
* `bool doGlobal     = true`
	* If it will compute Global muons efficiency.

Constructed objects

* `Type Tracker`
	* Stores all informations about Tracker muons.
* `Type Standalone`
	* Stores all informations about Standalone muons.
* `Type Global`
	* Stores all informations about Global muons.

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

Redefine number parameters of all mass histograms.

#### doFit()

```cpp
void doFit()
```

Apply a fit over all invariant mass stored.

#### fillMassHistograms(...)

```cpp
void fillMassHistograms(double** quantities,
						int** types)
```

Automatically fill all masses histograms. Needs to be called in a loop over all dataset.

#### fillQuantitiesHistograms(...)

```cpp
void fillQuantitiesHistograms(double** quantities,
							int** types)
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