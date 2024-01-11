# Validated Runs

Data recorded by CMS go through a validation process and are certified as good for physics analysis if all subdetectors, trigger, lumi and physics objects (tracking, electron, muon, photon, jet and MET) show the expected performance.

[Lists of validated runs and luminosity sections](http://opendata.cern.ch/search?page=1&size=20&type=Environment&subtype=Validation&experiment=CMS) (the smallest unit of data taking, 23 seconds) are provided on the CERN open data portal.

They are of format

 ``` shell
 {
     "<run number>":
      [
        [ 
            <first certified luminosity section in a range>, 
            <last certified luminosity section in a range>
        ],
        ..
 ```

for example:

``` shell
{"190645": [[10, 110]], "190646": [[1, 111]], "190659": [[33, 167]], "190679": [[1, 55]],
 "190688": [[69, 249]], "190702": [[51, 53], [55, 122], [124, 169]], "190703": [[1, 252]],
 "190704": [[1, 3]], ...
```

Each CMS open data record has a link to the corresponding list of validated runs, and it must be applied to all analyses. Most code examples expect that this list is downloaded to the working directory. In a CMSSW job, the filtering based on this list is applied by adding the following lines in the [configuration file](../../cmssw/cmsswconfigure.md) of the job

``` py
   import FWCore.ParameterSet.Config as cms
   import FWCore.PythonUtilities.LumiList as LumiList
   goodJSON = '<file name here>'
   myLumis = LumiList.LumiList(filename = goodJSON).getCMSSWString().split(',') 
```

and by adding these two lines after the `process.source` input file definition:

``` py
   process.source.lumisToProcess = cms.untracked.VLuminosityBlockRange()
   process.source.lumisToProcess.extend(myLumis)
```

This list should also be used as an input to the [luminosity calculation](../lumi.md).
