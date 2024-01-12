# Statistics

!!! Warning
    This page is under construction

## Overview of CMS techniques

CMS searches typically determine an observable or set of observables that is used to measure the potential presence of
signal events. This can be any observable, preferably highlighting unique features of the signal process.
Signal extraction is based on maximum likelihood fits that compare ``data'' (either collision data or pseudodata
sampled from a test distribution) to the signal (\(s\)) and background (\(b\)) predictions, with signal scaled by some
unknown ratio \(\mu\). The likelihood is assumed to follow a Poisson distribution, and all predictions are subject to various
nuisance parameters, \(\theta\), that are given default values \(\tilde{\theta}\) and assigned probability density functions (\(p\)).
The likelihood function can be written as:

\[
\mathcal{L}(\mathrm{data}\vert \mu,\theta) = \mathrm{Poisson}(\mathrm{data}\vert \mu\cdot s(\theta) + b(\theta))\cdot p(\tilde{\theta}\vert\theta).
\]

Systematic uncertainties are incorporated into the fit as nuisance parameters. Lognormal probability distributions are assigned
to uncertainties that affect only the normalization of a histogram or rate of a predicted event yield, and Gaussian probability
distributions are typically assigned to uncertainties provided as histograms that affect the shape of a distribution.
You can learn about several typical sources of uncertainty in CMS analyses in the [Systematics section](systematics/lumiuncertain.md)
of the Guide.

Observed and expected limits on the signal ratio \(\mu\) are extracted by comparing the compatibility
of the observed data with a background-only (\(\mu = 0\)) hypothesis as well as with a signal+background hypothesis.
The most common statistical method within CMS is the **CLs** method ([Read, 2002](https://iopscience.iop.org/article/10.1088/0954-3899/28/10/313) and [Junk, 1999](https://www.sciencedirect.com/science/article/pii/S0168900299004982)),
which can be used to obtain a limit at the 95% confidence level using the profile likelihood test statistic
([Cowan, 2010](https://arxiv.org/abs/1007.1727)) with the asymptotic limit approximation.

The ["Higgs Combine"](https://cms-analysis.github.io/HiggsAnalysis-CombinedLimit) software framework used by
the CMS experiment to compute limits is built on the [RooFit](https://root.cern/manual/roofit/) and
[RooStats](https://root.cern/doc/master/group__Roostats.html) packages and implements statistical procedures developed
for combining ATLAS and CMS Higgs boson measurements.

## Tutorials

Many tutorials and lectures on statistical interpretation of LHC data are available online. Some selected highlights are listed here.

- *Practical Statistics for LHC Physicists*, a set of three lectures by Prof. Harrison Prosper, 2015. Slides and videos are available for each lecture:

    - [Descriptive Statistics, Probability and Likelihood](https://indico.cern.ch/event/358542/)
    - [Frequentist Inference](https://indico.cern.ch/event/358543/)
    - [Bayesian Inference](https://indico.cern.ch/event/358544/)

- Higgs Combine [tutorial on the main features of Combine](https://cms-analysis.github.io/HiggsAnalysis-CombinedLimit/part5/longexercise/).

    - [Solutions](https://cms-analysis.github.io/HiggsAnalysis-CombinedLimit/part5/longexerciseanswers/) are available
    - Note: some links within this tutorial point to CMS internal resources.

- Open Data Workshop [*Simplified Run 2 Analysis* lesson](https://cms-opendata-workshop.github.io/workshopwhepp-lesson-ttbarljetsanalysis/)

    - Lessons from the Open Data Workshop series use the docker container environment recommended for processing Open Data.
    - The overall lesson offers tools for analysis of files in the NanoAOD or [PhysObjectExtractorTool](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool) format.
    - Specifically, the final page of the lesson (*5: Systematics and Statistics*) introduces the python-based tool [pyhf](https://pyhf.readthedocs.io/en/v0.7.6/) for performing statistical inference without any ROOT software.
