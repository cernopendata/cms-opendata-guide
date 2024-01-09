# class FitFunctions

This class hold all fit functions for histograms.

## class FitFunctions::Primary

This class is holding primary fit functions for histograms.

**Content list**

* double [Gaus(...)](#gaus)

* double [Pol1(...)](#pol1)

* double [Exp(...)](#exp)

* double [CrystalBall(...)](#crystalball)

**Functions details**

### Gaus(...)

```cpp
static double Gaus(double *x, double *par)
```

Parameters:

```cpp
par = [height, position, sigma]
```

### Pol1(...)

```cpp
static double Pol1(double *x, double *par)
```

Parameters:

```cpp
par = [b, a]
```

### Pol3(...)

```cpp
static double Pol3(double *x, double *par)
```

Parameters:

```cpp
par = [d, c, b, a]
```

### Exp(...)

```cpp
static double Exp(double *x, double *par)
```

Parameters:

```cpp
par = [height, width]
```

### CrystalBall(...)

```cpp
static double CrystalBall(double *x, double *par)
```

Parameters:

```cpp
par = [alpha, n, mean, sigma, yield]
```

## class FitFunctions::Merged

This class holds merged fit functions for histograms.

**Content list**

* double [Jpsi::Signal_InvariantMass()](#jpsisignal_invariantmass)

* double [Jpsi::Background_InvariantMass()](#jpsibackground_invariantmass)

* double [Jpsi::InvariantMass()](#jpsiinvariantmass)

* double [Upsilon::Signal_InvariantMass()](#upsilonsignal_invariantmass)

* double [Upsilon::Background_InvariantMass()](#upsilonbackground_invariantmass)

* double [Upsilon::InvariantMass()](#upsiloninvariantmass)

**Functions details**

### Jpsi::Signal_InvariantMass(...)

```cpp
static double Signal_InvariantMass(double *x, double *par)
```

Form:

[Gaus](#gaus)
+
[CrystalBall](#crystalball)

Parameters:

```cpp
par = [height, position, sigma, alpha, n, mean, sigma, yield]
```

### Jpsi::Background_InvariantMass(...)

```cpp
static double Background_InvariantMass(double *x, double *par)
```

Form:

[Exp](#exp)

Parameters:

```cpp
par = [b, a]
```

### Jpsi::InvariantMass(...)

```cpp
static double Signal_InvariantMass(double *x, double *par) + Background_InvariantMass(double *x, double *par)
```

Form:

[Gaus](#gaus)
+
[CrystalBall](#crystalball)
+
[Exp](#exp)

Parameters:

```cpp
par = [height1, position1, sigma1, alpha2, n2, mean2, sigma2, yield2, b, a]
```

### Upsilon::Signal_InvariantMass(...)

```cpp
static double Signal_InvariantMass(double *x, double *par)
```

Form:

[CrystalBall](#crystalball)
+
[Gaus](#gaus)
+
[Gaus](#gaus)

Parameters:

```cpp
par = [alpha1, n1, mean1, sigma1, yield1, height2, position2, sigma2, height3, position3, sigma3]
```

### Upsilon::Background_InvariantMass(...)

```cpp
static double Background_InvariantMass(double *x, double *par)
```

Form:

[Pol3](#pol3)

Parameters:

```cpp
par = [d, c, b, a]
```

### Upsilon::InvariantMass(...)

```cpp
static double Signal_InvariantMass(double *x, double *par) + Background_InvariantMass(double *x, double *par)
```

Form:

[CrystalBall](#crystalball)
+
[Gaus](#gaus)
+
[Gaus](#gaus)
+
[Pol3](#pol3)

Parameters:

```cpp
par = [alpha1, n1, mean1, sigma1, yield1, height2, position2, sigma2, height3, position3, sigma3, d, c, b, a]
```
