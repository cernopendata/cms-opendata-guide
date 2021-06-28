# Event Generation
<!-- markdownlint-disable -->
<!-- MarkdownTOC depth=0 -->

!!! Warning
    This page is under construction

Physical event [generation](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookGeneration) and detector simulation are the first steps in producing [Monte Carlo samples](http://opendata.cern.ch/docs/cms-mc-production-overview) suitable for physical analysis. Here we will teach you how to use the CMS datasets in the [CERN Open Data Portal](http://opendata.cern.ch/) and the [CMSSW](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookCMSSWFramework) machinery for the generation of events in simple steps:

1. **Generation and Simulation:** To simulate beam collisions.
2. **Triggers:** To simulate the effect of the detectors and electronics.
3. **Reconstruction:** For the reconstruction of the events in the collisions.

What you will find here:

* [Virtual machines](#virtual-machines) 
* [Dataset name](#dataset-name)
* [System details](#system-details)
* [Configuration files](#configuration-files)
* [cmsDriver](#cmsdriver)
* [Generation from Matrix Element (ME) generators](#matrix-element-generators)
    * [LHE](#me-lhe)
    * [Simulation](#me-simulation)
    * [High Level Trigger (HLT)](#me-hlt)
    * [Reconstruction](#me-reconstruction)
* [Generation from general-purpose generators](#general-purpose-generators)
    * [Generation and Simulation](#gp-generation-simulation)
    * [High Level Trigger (HLT)](#gp-hlt)
    * [Reconstruction](#gp-reconstruction)
* [Example for event generation with 2011 CMSSW machinery](#2011-cmssw)
* [Example for event generation with 2012 CMSSW machinery](#2012-cmssw)

<!-- /MarkdownTOC -->

<a name="virtual-machines"></a>
## Virtual machines

A specific CMS virtual machine includes the ROOT framework and CMSSW. Follow these [instructions](http://opendata.cern.ch/docs/cms-virtual-machine-2011) to configure a CERN virtual machine on your computer to be used with the 2011 and 2012 CMS open data.

<a name="dataset-name"></a>
## Dataset name

When exploring a simulated dataset on the [CERN Open Data Portal](http://opendata.cern.ch/), the first thing you will see is the name of the dataset. CMS uses the following [naming convention](http://opendata.cern.ch/docs/cms-simulated-dataset-names):
```
PROCESS_RANGETYPE-RANGELOWtoRANGEHIGH_FILTER_TUNE_COMMENT_COMENERGY-GENERATOR
```

Take as an example the name of record [12201](http://opendata.cern.ch/record/12201):
```
QCD_Pt-15to3000_TuneZ2star_Flat_8TeV_pythia6
```

<a name="system-details"></a>
## System details

In the record of each dataset, you can find the recommended [global tag](http://opendata.cern.ch/docs/cms-guide-for-condition-database) and release for analysis (CMSSW is the data analysis library). A global tag stores additional data that is required by the reconstruction and analysis software. Take as an example section *System details* of record [12201](http://opendata.cern.ch/record/12201):

```
Recommended global tag for analysis: START53_V27
Recommended release for analysis: CMSSW_5_3_32
```

<a name="configuration-files"></a>
## Configuration files

The CMS software framework uses a *software bus* model, where data is stored in the event which is passed to a series of modules. A single executable, `cmsRun`, is used, and the modules are loaded at runtime. A [configuration file](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookConfigFileIntro) defines which modules are loaded, in which order they are run, and with which configurable parameters they are run.

You can find the configuration files for the generation of events for each dataset in its respective record within the [CERN Open Data Portal](http://opendata.cern.ch/). Check, for example, the section *How were these data generated?* of record [12201](http://opendata.cern.ch/record/12201).

<a name="cmsdriver"></a>
## cmsDriver

The [cmsDriver](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideCmsDriver) is a tool to create production-solid configuration files from minimal command line options.  Its code implementation, the [cmsDriver.py](https://github.com/cms-sw/cmssw/blob/master/Configuration/Applications/scripts/cmsDriver.py) script, is part of the CMSSW software.  

A summary of the `cmsDriver.py` script's options with a detailed message about each one can be visualized by getting the help:
```
cmsDriver.py --help
```

<a name="matrix-element-generators"></a>
## Generation from Matrix Element (ME) generators

Generator-level datasets can be produced using a Matrix Element (ME) generator (e.g., [Powheg](http://powhegbox.mib.infn.it/), [MadGraph5_aMCatNLO](http://amcatnlo.web.cern.ch/amcatnlo/), [Alpgen](http://mlm.home.cern.ch/mlm/alpgen/)) to deliver the event at the parton level and then a general-purpose generator to hadronise the event.

Here we will reproduce the steps in the generation of record [1352](http://opendata.cern.ch/record/1352).

Guided by the system details specified in the dataset, you should start by setting up your run time environment:
```
cmsrel CMSSW_5_3_32
cd CMSSW_5_3_32/src/
cmsenv
```

We will create a package according to our dataset:
```
mkdir MyPackage
cd MyPackage
mkedanlzr MySim
```

<a name="me-lhe"></a>
### LHE

The Les Houches Event file format ([LHE](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideLHEInterface)) is an agreement between Monte Carlo event generators and theorists to define Matrix Element level event listings in a common language.

The LHE input file that store process and event information can be one generated by you or you can look for examples in `/eos/cms/store/lhe/`. Here we will use a file with events generated for record [1352](http://opendata.cern.ch/record/1352):

```
cmsDriver.py step1 --filein lhe:10270 --fileout file:LHE.root --mc --eventcontent LHE --datatier GEN --conditions START53_LV6A1::All --step NONE --python_filename LHE.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 3
```

Run the CMSSW executable:
```
cmsRun LHE.py
```

<a name="me-simulation"></a>
### Simulation

The next step is to generate fully hadronised events. We need to use the appropriate configuration file for this purpose. Take as an example the file in *Step SIM* for the simulation of record [1352](http://opendata.cern.ch/record/1352). The configuration file is in this [link](http://uaf-10.t2.ucsd.edu/~phchang/analysis/generator/genproductions/python/SevenTeV/Hadronizer_TuneZ2_7TeV_generic_LHE_pythia_tauola_cff.py).

We add this file to our local area:
```
curl http://uaf-10.t2.ucsd.edu/~phchang/analysis/generator/genproductions/python/SevenTeV/Hadronizer_TuneZ2_7TeV_generic_LHE_pythia_tauola_cff.py -o MySim/python/mysim.py
```

Compile everything:
```
scram b
```

Execute the `cmsDriver` command as:
```
cmsDriver.py MyPackage/MySim/python/mysim.py --filein file:LHE.root --fileout file:sim.root --mc --eventcontent RAWSIM --customise SimG4Core/Application/reproc2011_2012_cff.customiseG4,Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions START53_LV6A1::All --beamspot Realistic7TeV2011CollisionV2  --step GEN,SIM --datamix NODATAMIXER --python_filename sim.py --no_exec -n 3
```

Run the CMSSW executable:
```
cmsRun sim.py
```

<a name="me-hlt"></a>
### High Level Trigger (HLT)

It is a crucial part of the CMS data flow since it is the [HLT](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookHLTTutorial) algorithms and filters which will decide whether an event should be kept for an offline analysis: any offline analysis depends on the outcome of HLT.

Execute the `cmsDriver` command as:
```
cmsDriver.py step1 --filein file:sim.root --fileout file:hlt.root --mc --eventcontent RAWSIM --runsScenarioForMC Run2012_AB_C_D_oneRunPerEra --datatier GEN-RAW --conditions START53_LV6A1::All --step DIGI,L1,DIGI2RAW,HLT:2011 --python_filename hlt.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 3
```


Now, run the CMSSW executable:
```
cmsRun hlt.py
```

<a name="me-reconstruction"></a>
### Reconstruction

The algorithms that make up the CMS event [reconstruction](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookReco) software build physics objects (e.g., muons, electrons, jets) from the raw data recorded by the detector. All events collected by the CMS trigger system are reconstructed by the CMS prompt reconstruction system soon after being collected.

Execute the `cmsDriver` command as:
```
cmsDriver.py step2 --filein file:hlt.root --fileout file:reco.root --mc --eventcontent AODSIM,DQM --datatier AODSIM,DQM --conditions START53_LV6A1::All --step RAW2DIGI,L1Reco,RECO,VALIDATION:validation_prod,DQM:DQMOfflinePOGMC --python_filename reco.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 3
```

Now, run the CMSSW executable:
```
cmsRun reco.py
```

You can start ROOT and type `TBrowser t` to explore the files that were created.

<a name="general-purpose-generators"></a>
## Generation from general-purpose generators

Generator-level datasets can be produced using a general-purpose generator (e.g., [Pythia](http://home.thep.lu.se/~torbjorn/Pythia.html), [Herwig](https://herwig.hepforge.org/), [Tauola](https://tauolapp.web.cern.ch/tauolapp/)) to simulate the event and the hadronisation.

Here we will reproduce the steps in the generation of record [12201](http://opendata.cern.ch/record/12201).

Guided by the system details specified in the dataset, you should start by setting up your run time environment:
```
cmsrel CMSSW_5_3_32
cd CMSSW_5_3_32/src/
cmsenv
```

We will create a package according to our dataset:
```
mkdir MyPackage
cd MyPackage
mkedanlzr MyGen
```

<a name="gp-generation-simulation"></a>
### Generation and Simulation

We need to use the appropriate configuration file. Take as an example the file in *Step SIM* for the generation and simulation of record [12201](http://opendata.cern.ch/record/12201). The configuration file is in this [link](https://raw.githubusercontent.com/cms-sw/genproductions/master/python/EightTeV/QCD_Pt/QCD_Pt_15to3000_TuneZ2star_Flat_8TeV_pythia6_cff.py).

We add this file to our local area:
```
curl https://raw.githubusercontent.com/cms-sw/genproductions/master/python/EightTeV/QCD_Pt/QCD_Pt_15to3000_TuneZ2star_Flat_8TeV_pythia6_cff.py -o MyGen/python/mygen.py
```

Compile everything:
```
scram b
```

Execute the `cmsDriver` command as:
```
cmsDriver.py MyPackage/MyGen/python/mygen.py --fileout file:gen.root --mc --eventcontent RAWSIM --pileup NoPileUp --customise Configuration/StandardSequences/SimWithCastor_cff.customise,Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions START50_V13::All --beamspot Realistic8TeVCollision --step GEN,SIM --datamix NODATAMIXER --python_filename gen.py --no_exec -n 3
```

Run the CMSSW executable:
```
cmsRun gen.py
```

<a name="gp-hlt"></a>
### High Level Trigger (HLT)

Execute the `cmsDriver` command as:
```
cmsDriver.py step1 --filein file:gen.root --fileout file:hlt.root --pileup_input dbs:/MinBias_TuneZ2star_8TeV-pythia6/Summer12-START50_V13-v3/GEN-SIM --mc --eventcontent RAWSIM --runsScenarioForMC Run2012_AB_C_D_oneRunPerEra --pileup fromDB --datatier GEN-SIM-RAW --conditions START53_V7N::All --step DIGI,L1,DIGI2RAW,HLT:7E33v2 --python_filename hlt.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 3
```

In section *How were these data generated?* of the record, you can find the pile-up dataset. Additionally, you can manually add ROOT files to the `hlt.py`  file for the pile-up configuration by looking at the list of ROOT files that were used in the *Step HLT* configuration file of the record you are studying. This involves, for instance, opening file `hlt.py` and replacing the line

```
process.mix.input.fileNames = cms.untracked.vstring([])
```
with
```
process.mix.input.fileNames = cms.untracked.vstring([
'root://eospublic.cern.ch//eos/opendata/cms/MonteCarlo2012/Summer12/MinBias_TuneZ2star_8TeV-pythia6/GEN-SIM/START50_V13-v3/0000/005825F1-F260-E111-BD97-003048C692DA.root',
'root://eospublic.cern.ch//eos/opendata/cms/MonteCarlo2012/Summer12/MinBias_TuneZ2star_8TeV-pythia6/GEN-SIM/START50_V13-v3/0000/003EEBD4-8061-E111-9A23-003048D437F2.root', 
'root://eospublic.cern.ch//eos/opendata/cms/MonteCarlo2012/Summer12/MinBias_TuneZ2star_8TeV-pythia6/GEN-SIM/START50_V13-v3/0000/0005E496-3661-E111-B31E-003048F0E426.root'])
```

Now, run the CMSSW executable:
```
cmsRun hlt.py
```

<a name="gp-reconstruction"></a>
### Reconstruction

Execute the `cmsDriver` command as:
```
cmsDriver.py step2 --filein file:hlt.root --fileout file:reco.root --mc --eventcontent AODSIM,DQM --datatier AODSIM,DQM --conditions START53_V7N::All --step RAW2DIGI,L1Reco,RECO,VALIDATION:validation_prod,DQM:DQMOfflinePOGMC --python_filename reco.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 3
```

Now, run the CMSSW executable:
```
cmsRun reco.py
```

You can start ROOT and type `TBrowser t` to explore the files that were created.

<a name="2011-cmssw"></a>
## Example for event generation with 2011 CMSSW machinery

In this [example](https://github.com/cms-opendata-analyses/EventProductionExamplesTool/tree/2011), you will learn how to generate 2011 MC Drell-Yan events from scratch. A Drell-Yan process occurs when a quark and an antiquark annihilate, creating a virtual photon or Z boson, which then decays into a pair of oppositely charged leptons.

<a name="2012-cmssw"></a>
## Example for event generation with 2012 CMSSW machinery

In this [example](https://github.com/cms-opendata-analyses/EventProductionExamplesTool/tree/2012), you will learn how to generate 2012 MC QCD events, which involve the strong interaction between quarks and gluons. Additionally, you will know what are the steps to extract the tracking information of these events.

<!-- markdownlint-restore -->
