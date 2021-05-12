# struct MassValues

Holds informations about passing or all particles fit.

### Public variable details

Summary

| Type          | Name                 | Default value |
|---------------|----------------------|---------------|
| TH1D*         | hMass                | NULL          |
| TF1*          | fitFunction          | NULL          |
| TF1*          | fitSignal            | NULL          |
| TF1*          | fitBackground        | NULL          |
| double        | sidebandRegion1_x1   | 0.            |
| double        | sidebandRegion1_x2   | 0.            |
| double        | signalRegion_x1      | 0.            |
| double        | signalRegion_x2      | 0.            |
| double        | sidebandRegion2_x1   | 0.            |
| double        | sidebandRegion2_x2   | 0.            |
| TFitResultPtr | fitResult            | 0             |

<br>

### Public Functions details

#### createTBox(...)

```cpp
TBox* createTBox(double Ymax,
				int index = 0,
				double Ymin = 0.)
```

Return TBox of sideband or signal region.

* if  `index = -1` return TBox representing left sideband region.
* if  `index =  0` return TBox representing signal region.
* if  `index =  1` return TBox representing right sideband region.

#### doFitJpsi()

```cpp
void doFitJpsi()
```

Do fit for J/psi resonance.

#### doFitUpsilon()

```cpp
void doFitUpsilon()
```

Do fit for Upsilon resonance with 3 resonances peaks (1S, 2S, 3S).

#### doFitUpsilon1S()

```cpp
void doFitUpsilon1S()
```

Do fit for Upsilon (1S) resonance.

#### isInSidebandRegion(...)

```cpp
bool isInSidebandRegion(double InvariantMass)
```

Check if InvariantMass is in sideband region.

#### isInSignalRegion(...)

```cpp
bool isInSignalRegion(double InvariantMass)
```

Check if InvariantMass is in signal region.

#### subtractionFactor()

```cpp
double subtractionFactor()
```

Get the subtraction factor calculated by the ratio between yield of background particles in signal region by yield of background particles in sideband region. This yield is get by the integral of function stored in fitBackground variable.