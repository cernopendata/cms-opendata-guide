# Triggers

!!! Warning
    This page is under construction

When beginning a CMS analysis, there are three guiding principles to consider:

1. What physics objects should be present to represent the final state particles of my Feynman diagram? Should any of the objects be related to each other in a special way?
2. What physics objects should NOT be present?
3. What will cue CMS to store the types of events I want to analyze?

### Choosing things to keep
No physics object in CMS is reconstructed with absolute certainty. We always need to consider whether a reconstructed object is “genunine” or “fake”, and the pre-computed identification algorithms are designed to help analysts avoid considering “fake” objects that were caused by spurious information such as detector noise. Other considerations are whether objects are “prompt” or “nonprompt” (or “displaced”): muons from a Higgs boson 4-muon decay would be considered “prompt”; muons emerging from b-hadron decays within a jet would be considered “nonprompt”; and muons emerging far from the interaction point from the decay of some long-lived particle would be considered “displaced”. Identification and isolation algorithms can piece these differences apart, but each analysis will apply different choices. Jets carry information about the quark or boson that produced them, which is described as “tagging” in CMS. Analysts can choose to implement a jet tagging algorithm to select out jets with certain features.

### Choosing things to drop
All measurements and searches must consider background processes: reducible backgrounds with different final states that may pass event selection criteria due to some mismeasurement or fluctuation, and irreducible backgrounds with the same final state physics objects. Clever selection choices can often drop the rate of background processes significantly without sacrificing too many signal events. One basic example is the practice of using high momentum thresholds in searches for massive new physics particles, since SM processes with the same final state will preferentially result in low-momentum physics objects. Any physics object that can be selected can also be vetoed, depending on the needs of the analysis. An important part of this process is identifying and studying SM background processes!

### Choosing a set of triggers
Triggers determine which collision events are kept or discarded by CMS, so it sounds like this criterion should be chosen first, but in practice it is typically chosen last. Armed with a set of physics object selection criteria, we can search for a “trigger” or set of triggers that should have passed any event that will also pass the analysis criteria.

## The CMS Trigger System

Collisions at the LHC happen at a rate close to 40 million per second (40 MHz). Once each collision is sensed by the different subdetectors, the amount of information they generate corresponds to about what you can fit in a 1 MB file. If we were to record every single collision, it is said (you can do the math) that one can probably fill out all the available disk space in the world in a few days!

Not all collisions that happen at the LHC are interesting. We would like to keep the interesting ones and, most importantly, do not miss the discovery-quality ones. In order to achieve that we need a Trigger.

Before we jump into the details for the trigger system, let’s agree on some terminology:

Fill: Every time the LHC injects beams in the machine it marks the beginning of what is known as a Fill.

Run: As collisions happen in the LHC, CMS (and the other detectors) decide whether they start recording data. Every time the start button is pushed, a new Run starts and it is given a unique number.

Lumi section: while colliding, the LHC’s delivered instantaneous luminosity gets degraded (although during Run 3 it will be mainly levelled) due to different reasons. I.e., it is not constant over time. For practical reasons, CMS groups the events it collects in luminosity sections, where the luminosity values can be considered constant.

Deciding on which events to record is the main purpose of the trigger system. It is like determining which events to record by taking a quick picture of it and, even though a bit blurry, decide whether it is interesting to keep or not for a future, more thorough inspection.

CMS does this in two main steps. The first one, the Level 1 trigger (L1), implemented in hardware (fast FPGAs), reduces the input rate of 40 Mhz to around 100 KHz. The other step is the High Level Trigger (HLT), run on commercial machines with good-old C++ and Python, where the input rate is leveled around the maximum available budget of around 2 KHz.

There are hundreds of different triggers in CMS. Each one of them is designed to pick certain types of events, with different intensities and topologies. For instance the HLT_Mu20 trigger, will select events with at least one muon with 20 GeV of transverse momentum.

At the HLT level, which takes L1 as input, triggers are implemented using the primary CMS software, CMSSW, using pieces of it (“modules”) that can be arranged to achieve the desired result: selecting specific kinds of events. Computationally, triggers are CMSSW “Paths”, and one could extract a lot of information by exploring the Python configuration of these paths. Within CMS, data is processed using C++ source code configured using Python. An example of a trigger path in a python configuration file might look like this:

```python
process.HLT_Mu20_v2 = cms.Path( process.HLTBeginSequence + process.hltL1sL1SingleMu16 + process.hltPreMu20 + process.hltL1fL1sMu16L1Filtered0 + process.HLTL2muonrecoSequence + process.hltL2fL1sMu16L1f0L2Filtered10Q + process.HLTL3muonrecoSequence + process.hltL3fL1sMu16L1f0L2f10QL3Filtered20Q + process.HLTEndSequence )
```

Triggers are code, and those pieces of code are constantly changing. Modifications to a trigger could imply a different version identifier. For instance, our HLT_Mu20 could actually be HLT_Mu15_v1 or HLT_Mu15_v2, etc., depending on the version. Therefore, it is completely normal that the trigger names can change from run to run.

## Trigger Prescales

The need for prescales (and its meaning) is evident if one thinks of different physics processes having different cross sections. It is a lot more likely to record one minimum bias event, than an event where a Z boson is produced. Even less likely is to record an event with a Higgs boson. We could have triggers named, say, HLT_ZBosonRecorder for the one in charge of filtering Z-carrying events, or HLT_HiggsBosonRecorder for the one accepting Higgses (the actual names are more sophisticated and complex than that, of course.) The prescales are designed to keep these inputs under control by, for instance, recording just 1 out of 100 collisions that produce a likely Z boson, or 1 out of 1 collisions that produce a potential Higgs boson. In the former case, the prescale would be 100, while for the latter it would be 1; if a trigger has a prescale of 1, i.e., records every single event it identifies, we call it unprescaled.

Maybe not so evident is the need for trigger prescale changes for keeping up with luminosity changes. As the luminosity drops, prescales can be relaxed, and therefore could change from to run in the same fill. A trigger can be prescaled at L1 as well as the HLT levels. L1 triggers have their own nomenclature and can be used as HLT trigger seeds.

## Triggers and CMS Data Streams

After events are accepted by possibly more than one type of trigger, they are streamed in different categories, called streams and then classified and arranged in primary datasets. Most, but not all, of the datasets belonging to the stream A, the physics stream, are or will become available as CMS Open Data.

Finally, it is worth mentioning that:

 * an event can be triggered by many trigger paths
 * trigger paths are unique to each dataset
 * the same event can arrive in two different datasets (this is speciall important if working with many datasets as event duplication can happen and one has to account for it)

For example, you can expect that an event containing two top quarks, one of which decays to an electron and the other of which decays to a muon, could appear in several datasets: the single muon dataset, the single electron dataset, the "muon + electron" dataset, and perhaps the jet dataset since there will also be two b quark jets. For an analysis studying dileptonic top pair production, the "muon + electron" dataset is almost certainly the best choice.

## Accessing trigger information

On all CMS Open Data portal records for data samples, the list of trigger paths that feed into that dataset are listed on the webpage. For example, in [this 2012 data sample](https://opendata.cern.ch/record/6024) the trigger paths are lsited, and each are clickable links to [individual trigger records](https://opendata.cern.ch/record/6392) that provide more information about that path.

=== AOD format (Run 1)

For exercises exploring trigger information in Run 1, visit [this AOD trigger lesson](https://cms-opendata-workshop.github.io/workshop2021-lesson-introtrigger/) from an Open Data Workshop. A [`TriggerInfoTool`](https://opendata.cern.ch/record/5004) was prepared for extracting trigger information in Run 1 data. This tool is presented in the workshop lesson, and has detailed usage instructions in the source code repository.

=== MiniAOD format (Run 2)

To follow this information as an exercise, visit [this MiniAOD trigger lesson](https://cms-opendata-workshop.github.io/workshop2023-lesson-selection/index.html) from an Open Data Workshop.

### Trigger results stored in MiniAOD files

Investigating MiniAOD files requires the CMSSW environment, described on the [MiniAOD getting started guide](https://opendata.cern.ch/docs/cms-getting-started-miniaod).

Multiple collections of type `edm::TriggerResults` can be found in MiniAOD files:

```bash
edmDumpEventContent root://eospublic.cern.ch//eos/opendata/cms/mc/RunIIFall15MiniAODv2/TT_TuneCUETP8M1_13TeV-powheg-pythia8/MINIAODSIM/PU25nsData2015v1_76X_mcRun2_asymptotic_v12_ext3-v1/00000/02837459-03C2-E511-8EA2-002590A887AC.root
```

You should see the following lines that reference triggers in some way:

```output
Type                                  Module                      Label             Process   
----------------------------------------------------------------------------------------------
edm::TriggerResults                   "TriggerResults"            ""                "SIM"     
edm::TriggerResults                   "TriggerResults"            ""                "HLT"     
edm::TriggerResults                   "TriggerResults"            ""                "RECO"    
edm::TriggerResults                   "TriggerResults"            ""                "PAT"     
pat::PackedTriggerPrescales           "patTrigger"                ""                "PAT"     
pat::PackedTriggerPrescales           "patTrigger"                "l1max"           "PAT"     
pat::PackedTriggerPrescales           "patTrigger"                "l1min"           "PAT"     
vector<pat::TriggerObjectStandAlone>    "selectedPatTrigger"        ""                "PAT"     
```

There are various entries of type `edm::TriggerResults`, but we are specifically interested in the one labelled "HLT" that contains the pass/fail information for HLT paths.
In the "PAT" collection section we also find `selectedPatTrigger` and `patTrigger` collections.

Although we do not have such analyzer yet, we know where to find information on how to implement it.  If we go to the [WorkBookMiniAOD2015](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookMiniAOD2015#Trigger) or [WorkBookMiniAOD2016](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookMiniAOD2016#Trigger) CMS Twiki pages, we find some "example CMSSW code" provided on how to build an EDanalyzer with its corresponding configuration. This example code prints out a variety of information about the triggers, they can also be stored for programmatic access.

The pass/fail information for each event is accessed as follows:

```cpp
#include "FWCore/Common/interface/TriggerNames.h"
#include "DataFormats/Common/interface/TriggerResults.h"

class MiniAODTriggerAnalyzer : public edm::EDAnalyzer {
   public:
      explicit MiniAODTriggerAnalyzer (const edm::ParameterSet&);
      ~MiniAODTriggerAnalyzer() {}

   private:
      virtual void analyze(const edm::Event&, const edm::EventSetup&) override;

      edm::EDGetTokenT triggerBits_;
};

MiniAODTriggerAnalyzer::MiniAODTriggerAnalyzer(const edm::ParameterSet& iConfig):
    triggerBits_(consumes(iConfig.getParameter("bits"))),
{
}

void MiniAODTriggerAnalyzer::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
    edm::Handle triggerBits;

    iEvent.getByToken(triggerBits_, triggerBits);

    const edm::TriggerNames &names = iEvent.triggerNames(*triggerBits);
    for (unsigned int i = 0, n = triggerBits->size(); i < n; ++i) {
        std::cout << "Trigger " << names.triggerName(i) << ": " << (triggerBits->accept(i) ? "PASS" : "fail (or not run)") << std::endl;
    }

}

//define this as a plug-in
DEFINE_FWK_MODULE(MiniAODTriggerAnalyzer);
```

A `cmsRun` configuration file for this small analyzer would provide the HLT TriggerResults collection for the object called `bits`:

```python
import FWCore.ParameterSet.Config as cms

process = cms.Process("Demo")

process.load("FWCore.MessageService.MessageLogger_cfi")
process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(10) )

process.source = cms.Source("PoolSource",
    fileNames = cms.untracked.vstring('root://eospublic.cern.ch//eos/opendata/cms/Run2015D/SingleElectron/MINIAOD/08Jun2016-v1/10000/001A703B-B52E-E611-BA13-0025905A60B6.root')
)

process.demo = cms.EDAnalyzer("MiniAODTriggerAnalyzer",
    bits = cms.InputTag("TriggerResults","","HLT"),
)

process.p = cms.Path(process.demo)
```

### The HLTConfigProvider and HLTPrescaleProvider

While it is true that one can get most of the trigger information needed directly from the miniAOD files, there are some cases when this information is not enough.  An example is the case of multi-object triggers.  If one needs to study a trigger in detail it is likely that the [HLTConfigProvider](https://github.com/cms-sw/cmssw/blob/CMSSW_7_6_X/HLTrigger/HLTcore/interface/HLTConfigProvider.h) and the [HLTPrescaleProvider](https://github.com/cms-sw/cmssw/blob/CMSSW_7_6_X/HLTrigger/HLTcore/interface/HLTPrescaleProvider.h) classes are needed. As you can check for yourself these clases have several methods to extract a lot of trigger-related information. Several of those, like the ones related to prescale extraction, need access to the **conditions database**.

The [Physics Object Extractor Tool for 2015](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2015MiniAOD/) features a [trigger EDanalyzer](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2015MiniAOD/PhysObjectExtractor/src/TriggObjectAnalyzer.cc). This analyzer stores a map with the names of interesting triggers and their acceptance and prescale information.

=== NanoAOD format (Run 2, 2016 onward)

For many physics analyses, one basic piece of trigger information is required: did this event pass or fail a certain path?
NanoAOD stores this information for both L1 and HLT paths. Let's consider 3 example HLT paths:

 * HLT_Ele35_WPTight_Gsf
 * HLT_IsoMu27
 * HLT_IsoMu27_LooseChargedIsoPFTauHPS20_Trk1_eta2p1_SingleL1

The first element of the name indicates that these paths are part of the "High Level Trigger" mentioned in the introduction.
The second element of the name shows the first physics object that was tested for this path -- the first example is an electron trigger, and the other two are muon triggers.
Following the short name "Ele" or "Mu" is a momentum/energy threshold for this object, measured in GeV. The example "HLT_IsoMu27" has another feature in the name: "Iso". This indicates that the muon is required to be isolated. Adding isolation requirements helps keep the momentum threshold for this popular trigger low without overwhelming the CMS trigger bandwidth.

The final example shows a trigger with multiple objects -- after the "IsoMu27" label comes a label related to tau leptons: "LooseChargedIsoPFTauHPS20_Trk1_eta2p1_SingleL1".
This is a complex label that would share with experts many details of how the tau passing this trigger appeared in the CMS calorimeters. The most important information is that
this tau lepton decayed to hadrons (note the "HPS" label for "hadron plus strips), was loosely isolated from other charged hadrons, passed a 20 GeV threshold, and was found in the central region of the detector ($\eta < 2.1$). This trigger might be used for a $H \rightarrow \tau \tau$ analysis with one hadronic tau and one tau that decayed to a muon. 

### NanoAOD branch listings

Each dataset's record page contains a link to its variable listing, which will show the full list of L1 and HLT paths available in that dataset. We will show short examples below.

Note:

 * No version number appears in the branch names! NanoAOD assumes you want all versions of a trigger
 * All the branches are type "bool", so they indicate pass (true) or fail (false) for the event
 * Some L1 paths relate to detector conditions, and some to energy thresholds
 * Many triggers of the same type exist with a variety of energy or momentum thresholds

Table: L1 information in NanoAOD (truncated example)

| Object property | Type | Description |
| --------------- | ---- | ----------- |
| L1_AlwaysTrue | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BPTX_AND_Ref4_VME | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BPTX_BeamGas_B1_VME | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BPTX_BeamGas_B2_VME | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BPTX_BeamGas_Ref1_VME | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BPTX_BeamGas_Ref2_VME | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BPTX_NotOR_VME | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BptxMinus | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BptxOR | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BptxPlus | Bool_t | Trigger/flag bit (process: NANO) |
| L1_BptxXOR | Bool_t | Trigger/flag bit (process: NANO) |
| L1_CDC_SingleMu_3_er1p2_TOP120_DPHI2p618_3p142 | Bool_t | Trigger/flag bit (process: NANO) |
| L1_DoubleEG8er2p5_HTT260er | Bool_t | Trigger/flag bit (process: NANO) |
| L1_DoubleEG8er2p5_HTT320er | Bool_t | Trigger/flag bit (process: NANO) |
| L1_DoubleEG8er2p5_HTT340er | Bool_t | Trigger/flag bit (process: NANO) |
| L1_DoubleEG_15_10_er2p5 | Bool_t | Trigger/flag bit (process: NANO) |
| L1_DoubleEG_20_10_er2p5 | Bool_t | Trigger/flag bit (process: NANO) |

Table: HLT information in NanoAOD (truncated example)

| Object property | Type | Description |
| --------------- | ---- | ----------- |
| HLT_Ele30_WPTight_Gsf | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Ele30_eta2p1_WPTight_Gsf_CentralPFJet35_EleCleaned | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Ele32_WPTight_Gsf | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Ele32_WPTight_Gsf_L1DoubleEG | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Ele35_WPTight_Gsf | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Ele35_WPTight_Gsf_L1EGMT | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Ele38_WPTight_Gsf | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoMu27 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoMu27_LooseChargedIsoPFTauHPS20_Trk1_eta2p1_SingleL1 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoMu27_MET90 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoMu27_MediumChargedIsoPFTauHPS20_Trk1_eta2p1_SingleL1 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoMu27_TightChargedIsoPFTauHPS20_Trk1_eta2p1_SingleL1 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoMu30 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoTrackHB | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_IsoTrackHE | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Mu48NoFiltersNoVtx_Photon48_CaloIdL | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Mu4_TrkIsoVVL_DiPFJet90_40_DEta3p5_MJJ750_HTT300_PFMETNoMu60 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Mu50 | Bool_t | Trigger/flag bit (process: HLT) |
| HLT_Mu50_IsoVVVL_PFHT450 | Bool_t | Trigger/flag bit (process: HLT) |

### L1 PreFiring corrections

The 2016 NanoAOD files also contain a set of branches labeled "L1PreFiringWeight". In 2016 and 2017, the gradual timing shift of the ECAL was not properly propagated to the L1 trigger system, resulting in a significant fraction of high-$\eta$ "trigger primitives" being mistakenly associated to the previous bunch crossing. Since Level-1 rules forbid two consecutive bunch crossings from firing, an unpleasant consequence of this is that events can effectively "self veto" if a significant amount of ECAL energy is found in the region $2.0 < |\eta| < 3.0$. The effect is strongly $\eta$- and $p_{T}$-dependent and prefiring rates can be large for high-momentum jets in the forward regions of the detector. A similar effect is present in the muon system, where the bunch crossing assignment of the muon candidates can be wrong due to the limited time resolution of the muon detectors. This effect was most pronounced in 2016, and the magnitude varies between 0% and 3%. 

The L1PreFiring table in NanoAOD provides weights that analysts can apply to simulation to correct for these effects, so that simulation better represents data. The weights carry associated uncertainties, represented in alternate branches. 

| Object property | Type | Description |
| --------------- | ---- | ----------- |
| L1PreFiringWeight_Dn | Float_t | L1 pre-firing event correction weight (1-probability), down var. |
| L1PreFiringWeight_ECAL_Dn | Float_t | ECAL L1 pre-firing event correction weight (1-probability), down var. |
| L1PreFiringWeight_ECAL_Nom | Float_t | ECAL L1 pre-firing event correction weight (1-probability) |
| L1PreFiringWeight_ECAL_Up | Float_t | ECAL L1 pre-firing event correction weight (1-probability), up var. |
| L1PreFiringWeight_Muon_Nom | Float_t | Muon L1 pre-firing event correction weight (1-probability) |
| L1PreFiringWeight_Muon_StatDn | Float_t | Muon L1 pre-firing event correction weight (1-probability), down var. stat. |
| L1PreFiringWeight_Muon_StatUp | Float_t | Muon L1 pre-firing event correction weight (1-probability), up var. stat. |
| L1PreFiringWeight_Muon_SystDn | Float_t | Muon L1 pre-firing event correction weight (1-probability), down var. syst. |
| L1PreFiringWeight_Muon_SystUp | Float_t | Muon L1 pre-firing event correction weight (1-probability), up var. syst. |
| L1PreFiringWeight_Nom | Float_t | L1 pre-firing event correction weight (1-probability) |
| L1PreFiringWeight_Up | Float_t | L1 pre-firing event correction weight (1-probability), up var. |
 
### What's missing from NanoAOD?

NanoAOD does not contain information about trigger **prescales** or **objects**. A trigger object is a link to the electron, muon, jet, tau, etc, that specifically satisfied the criteria for a given trigger filter.

Prescale information is fixed in the "trigger menu", so it can be accessed outside of NanoAOD. While it's common for prescale values to change from run to run, most
analysts are only interested in determining whether or not a trigger is prescaled at all. If not, that trigger is a good candidate for analyses requiring the full 
amount of data available. If so, the trigger is better suited to studies where statistics are not a limiting factor. Prescale values for any trigger can be accessed 
from the `brilcalc` tool. To practice, follow the [trigger and luminosity exercise from an Open Data workshop](https://cms-opendata-workshop.github.io/workshop2024-lesson-triggers-lumi/instructor/05-challenge.html).

Trigger object information is important if an analysis needs to know which specific objects passed a certain set of trigger filters. So for instance, if you needed
to know which tau leptons satisfied `LooseChargedIsoPFTauHPS20_Trk1_eta2p1_SingleL1` in order to make correct analysis choices, then you would need access to trigger
object details. Many analyses do not require this level of detail, since physics objects can usually be selected using the identification and isolation algorithms designed
to be applied separately from the trigger system. Trigger objects can be accessed in MiniAOD.
