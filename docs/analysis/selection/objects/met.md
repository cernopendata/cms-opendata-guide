#  MET



## What is MET?

[Missing transverse momentum](https://cds.cern.ch/record/1543527) is the negative vector sum of the transverse momenta of all particle flow candidates in an event. The magnitude of the missing transverse momentum vector is called missing transverse energy and referred to with the acronym “MET”. Since energy corrections are made to the particle flow jets, those corrections are propagated to MET by adding back the momentum vectors of the original jets and then subtracting the momentum vectors of the corrected jets. This correction is called “Type 1” and is standard for all CMS analyses. The jet energy corrections will be discussed more deeply at the end of this lesson.

In [MetAnalyzer.cc](https://github.com/cms-legacydata-analyses/PhysObjectExtractorTool/blob/master/PhysObjectExtractor/src/MetAnalyzer.cc) we open the particle flow MET module and extract the magnitude and angle of the MET, the sum of all energy in the detector, and variables related to the “significance” of the MET. Note that MET quantities have a single value for the entire event, unlike the objects studied previously.

```
Handle<PFMETCollection> met;
iEvent.getByLabel(InputTag("pfMet"), met);

value_met_pt = met->begin()->pt();
value_met_phi = met->begin()->phi();
value_met_sumet = met->begin()->sumEt();

value_met_significance = met->begin()->significance();
auto cov = met->begin()->getSignificanceMatrix();
value_met_covxx = cov[0][0];
value_met_covxy = cov[0][1];
value_met_covyy = cov[1][1];
```

MET significance can be a useful tool: it describes the likelihood that the MET arose from noise or mismeasurement in the detector as opposed to a neutrino or similar non-interacting particle. The four-vectors of the other physics objects along with their uncertainties are required to compute the significance of the MET signature. MET that is directed nearly (anti)colinnear with a physics object is likely to arise from mismeasurement and should not have a large significance.

The difference between the Drell-Yan events with primarily fake MET and the top pair events with primarily genuine MET can be seen by drawing MET_pt or by drawing MET_significance. In both distributions the Drell-Yan events have smaller values than the top pair events.







!!! Warning
    This page is under construction
