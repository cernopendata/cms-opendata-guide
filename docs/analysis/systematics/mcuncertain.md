# MC Uncertainty

!!! Warning
    This page is under construction

When using simulation to model any physics process, uncertainties affecting the choices made in the generator should be taken into account. These uncertainties commonly include variations in the renormalization and/or factorization scale, which represents uncertainty due to missing higher orders in the generation, and uncertainty from the parton distribution function used in the simulation. For studies of some physics processes, notably in top quark physics, other generator parameters may be varied to produce separate simulations that can be compared to the primary simulation.

## Renormalization and factorization scale

In any perturbative quantum chromodynamics calculations, a renormalization scale $\mu_R$ must be set in order to compute observables at some fixed order of the perturbation. A factorization scale $\mu_F$ is also chosen to determine the resolution with which the parton distribution function for the colliding protons will be probed, separating "hard scattering" interaction elements from less significant contributions. Most CMS simulations released to date are accurate to either leading order or next-to-leading order. The choice for these scale values is not strictly determined by theory, but is often set to correspond to the mass scale of massive particles being generation (e.g., $\mu_R = \mu_F = M_Z$). In CMS, the most common approach to determining an uncertainty due to the choice of scales is to store event weights corresponding to the following 6 variations:

- $\mu_R$ multiplied by 0.5, and also multiplied by 2.
- $\mu_F$ multiplied by 0.5, and also multiplied by 2.
- Both scales simultaneously multiplied by 0.5, and also simultaneously multiplied by 2.

For some final observable, such as the distribution of the reconstructed mass of a particle, the uncertainty is evaluated by taking the **envelope** of predictions from all of the variations. So in each bin of a histogram you would compute the number of events in that bin for each of the 7 possibilities. The uncertainty "down" is the smallest number of events, and the uncertainty "up" is the largest number of events. Repeating this calculation in all bins of a histogram can produce new histograms for the "down" and "up" scale variations.

Since the scales are often set based on the mass of the simulated particle, it is often best to treat the scale uncertainty for one process as uncorrelated from the scale uncertainty for other processes. For example, the scale uncertainty for top quark simulations might be kept separate from the scale uncertainty for W or Z production, etc.

### Accessing scale variation weights

The renormalization and factorization scale weights can be accessed in any Open Data format from CMS, though the details vary:

=== "AOD or MiniAOD files"

In AOD and MiniAOD files, the scale variation weights can be accessed from the `externalLHEProducer` collection.

``` cpp
// Include this line in the class definition of your EDAnalyzer:
edm::EDGetTokenT<LHEEventProduct> LHEEPtoken;

// Include these lines in the constructor function of your EDAnalyzer:
edm::InputTag LHEEPtag("externalLHEProducer");
LHEEPtoken = consumes<LHEEventProduct>(LHEEPtag);

// Include the following code in the "analyze" function of your EDAnalyzer:
std::vector<double> LHEweights;
std::vector<int> LHEweightids;

edm::Handle<LHEEventProduct> EvtHandle;
if(iEvent.getByToken(LHEEPtoken,EvtHandle)){

  LHEweightorig = EvtHandle->originalXWGTUP();
  std::string weightidstr;
  int weightid;
  if(EvtHandle->weights().size() > 0){
    for(unsigned int i = 0; i < EvtHandle->weights().size(); i++){
      weightidstr = EvtHandle->weights()[i].id;
      weightid = std::stoi(weightidstr);
      LHEweights.push_back(EvtHandle->weights()[i].wgt/EvtHandle->originalXWGTUP());
      LHEweightids.push_back(weightid);
    }
  }
```

In your analyzer, you might store the vectors `LHEweights` and `LHEweightids` into branches of a `TTree` for further analysis in a non-CMS format, or use them directly to produce histograms. The vector of ID numbers helps with interpretation of the contents. Scale variations are typically stored using ID numbers 1 - 9, or 1001 - 1009, based on the generator used. The ordering is:

- (100)1 has $\mu_R \times 1$ and $\mu_F \times 1$,
- (100)2 has $\mu_R \times 1$ and $\mu_F \times 2$,
- (100)3 has $\mu_R \times 1$ and $\mu_F \times 0.5$,
- (100)4 has $\mu_R \times 2$ and $\mu_F \times 1$,
- (100)5 has $\mu_R \times 2$ and $\mu_F \times 2$,
- (100)6 has $\mu_R \times 2$ and $\mu_F \times 0.5$ (**this variation is NOT typically considered when forming an uncertainty**),
- (100)7 has $\mu_R \times 0.5$ and $\mu_F \times 1$,
- (100)8 has $\mu_R \times 0.5$ and $\mu_F \times 2$ (**this variation is NOT typically considered when forming an uncertainty**),
- (100)9 has $\mu_R \times 0.5$ and $\mu_F \times 0.5$

To confirm the weight ID numbers used for scale variations, see the PDF uncertainty section below for instructions to print LHE header information. The first section of the printout shows the weight IDs that correspond to the scale variations.

=== "NanoAOD files"

NanoAOD files contain a branch called `LHEScaleWeight` in the `Events` tree, which is a vector of floating point values. For each event, the vector contains:

- [0] has $\mu_R \times 0.5$ and $\mu_F \times 0.5$,
- [1] has $\mu_R \times 0.5$ and $\mu_F \times 1$,
- [2] has $\mu_R \times 0.5$ and $\mu_F \times 2$ (**this variation is NOT typically considered when forming an uncertainty**),
- [3] has $\mu_R \times 1$ and $\mu_F \times 0.5$,
- [4] has $\mu_R \times 1$ and $\mu_F \times 1$ (**some simulations do not include this vector element, check the variable listing page**. If it is not included, all of the later vector elements are in the same order but have an index that is one unit smaller.),
- [5] has $\mu_R \times 1$ and $\mu_F \times 2$,
- [6] has $\mu_R \times 2$ and $\mu_F \times 0.5$ (**this variation is NOT typically considered when forming an uncertainty**),
- [7] has $\mu_R \times 2$ and $\mu_F \times 1$,
- [8] has $\mu_R \times 2$ and $\mu_F \times 2$,

The `Runs` tree also contains a branch called `LHEScaleSumw`, which contains the sum of weights for each scale variation (using the same vector ordering described above) divided by the standard sum of event weights. The contents of the `Runs` tree are not affected by any selection applied to branches in the `Events` tree. This is useful for determining how the magnitude of the scale uncertainty changes based on event selection. If an observable has the same scale variation as the original sample with no selection applied, then the entire scale uncertainty is due to generation settings. Some CMS searches for new physics particles, whose simulations are often produced at leading order, factor out this original scale variation and only consider the "net" scale variation introduced by event selection.

## Parton distribution functions

Parton distribution functions (PDFs) describe the probability for finding, within a proton, a parton of a certain flavor and momentum fraction. These distributions are always being refined to better and better precision using data collected by particle physics experiments, however they do carry various uncertainties. The uncertainties in a PDF are provided by the collaborations that produce them according to two methods:

- Monte Carlo replicas: in this method many "replicas" are made of the PDF based on random variations of parameters. The set of replicas forms a distribution whose width represents the uncertainty in the PDF.
- Hessian uncertainties: in this method uncertainties in the PDF are factorized from each other. For each Hessian variation, the deviation from the central PDF estimate is added in quadrature to the other variations.

Forming PDF uncertainty histograms for an observable depends on the type of variations provided. A helpful summary of the mathematical methods is found in section 6.2 of the paper ["PDF4LHC recommendations for LHC Run II"](https://arxiv.org/pdf/1510.03865). The example of computing uncertainty in a cross section is used, but the same formulas can apply if the observable is the number of events in a given bin of a histogram. In CMS simulation, weights are stored for many different PDF sets, using the [LHAPDF](https://lhapdf.hepforge.org/pdfsets.html) numbering scheme. The default PDF sets for CMS simulations come from the NNPDF family.

### Accessing PDF variation weights

The PDF variation weights can be accessed in any Open Data format from CMS, though the details vary:

=== "AOD or MiniAOD files"

The same code provided above the accessing the scale variation weights is used to acccess PDF variations. Again, the ID numbers help associate weight values to specific PDF variations, though note that **these ID numbers are NOT equal to LHAPDF numbers**. The default PDF and its variations can usually be found in ID numbers 10 - 110, 1010 - 1110, or 2000 - 2100. If the PDF set included $\alpha_S$ variations, those two variations will fall immediately after the PDF variations. The best way to be certain of the PDF is to print out the LHE header information. To do so, include the following code in the `beginRun()` function of an EDAnalyzer:

``` cpp
edm::Handle<LHERunInfoProduct> run; 
typedef std::vector<LHERunInfoProduct::Header>::const_iterator headers_const_iterator;

iRun.getByLabel( "externalLHEProducer", run );
LHERunInfoProduct myLHERunInfoProduct = *(run.product());

for (headers_const_iterator iter=myLHERunInfoProduct.headers_begin(); iter!=myLHERunInfoProduct.headers_end(); iter++){
  std::cout << iter->tag() << std::endl;
  std::vector<std::string> lines = iter->lines();
  for (unsigned int iLine = 0; iLine<lines.size(); iLine++) {
   std::cout << lines.at(iLine);
  }
}
```

The printout will include segments like the following example, which shows the weight ID numbers for the LHAPDF set that uses numbers starting at 260001. The LHAPDF numbers would be found on the website linked above. The printout includes information about whether the PDF set used either "hessian" or "replicas" for the uncertainty. Events can be reweighted to use any PDF set included in the weights list.

``` output
<weightgroup combine="hessian" name="PDF_variation">
<weight id="2001"> PDF set = 260001 </weight>
<weight id="2002"> PDF set = 260002 </weight>
<weight id="2003"> PDF set = 260003 </weight>
<weight id="2004"> PDF set = 260004 </weight>
<weight id="2005"> PDF set = 260005 </weight>
<weight id="2006"> PDF set = 260006 </weight>
<weight id="2007"> PDF set = 260007 </weight>
...etc...
```

=== "NanoAOD files"

NanoAOD files contain a branch called `LHEPdfWeight` in the `Events` tree, which is a vector of floating point values. For each event, the vector contains values of $w_{\mathrm{variation}}/w_{\mathrm{nominal}}$ for each variation in the PDF set. The NanoAOD variable listing for each dataset will indicate which LHAPDF set was stored. The documentation line for `LHEPdfWeight` will say: "LHE pdf variation weights (w_var / w_nominal) for LHA IDs 306000 - 306102" (where the numerical values may change based on the sample). The LHA ID numbers can be cross-referenced to the LHAPDF website linked above.

The `Runs` tree also contains a branch called `LHEPdfSumw`, which contains the sum of weights for each PDF variation divided by the standard sum of event weights. The contents of the `Runs` tree are not affected by any selection applied to branches in the `Events` tree. This is useful for determining how the magnitude of the PDF uncertainty changes based on event selection. If an observable has the same PDF uncertainty as the original sample with no selection applied, then the entire PDF uncertainty is due to generation settings. Some CMS searches for new physics particles, whose simulations are often produced at leading order, factor out this original PDF uncertainty and only consider the "net" PDF uncertainty introduced by event selection.

## Variations of generator parameters

Many other parameters can be modified in simulations, particularly related to parton shower programs and matching/merging techniques. These variations may be more difficult to capture as event weights. In this case, separate samples, often with fewer events, are generated to supplement a primary simulation. For example, the following [open data portal search](https://opendata.cern.ch/search?q=%2FTTToSemiLeptonic%2A%20%26%26%20%2ATuneCP5_%2A&f=experiment%3ACMS&f=file_type%3Ananoaodsim&f=category%3AStandard%20Model%20Physics%2Bsubcategory%3ATop%20physics&l=list&order=asc&p=1&s=10&sort=bestmatch) shows many variations for top quark pair production with one leptonic decay. The primary simulation, the first in the list, contains 144722000 events, while one of the "hdamp" variation contains 60649000 events. The uncertainty can be computed by calculating an observable using the alternate simulations labeled as the "up" and "down" variations of a certain parameter, and if needed applying a smoothing algorithm to the obserable to mimic the statistical power of the primary simulation.
