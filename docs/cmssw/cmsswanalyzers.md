# Analyzers

First, a few general words about analysis in the CMSSW framework. Physics analysis proceeds via a series of subsequent steps. Building blocks are identified and more complex objects are built on top of them. How to write a Framework Module and run the job with the `cmsRun` can be found [here](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookWriteFrameworkModule).

When setting up code for the new EDM (such as creating a new EDProducer) there is a fair amount of 'boiler plate' code that you must write. To make writing such code easier CMS provides a series of scripts that will generate the necessary directory structure and files needed so that all you need to do is write your actual algorithms.

CMSSW distiguishes the following [module types](https://twiki.cern.ch/twiki/bin/view/Main/CMSSWatFNALFramework#Module_types):

- **EDAnalyzer:** takes input from the event and processes the input without writing information back to the event
- **EDProducer:** takes input from the event and produces new output which is saved in the event
- **EDFilter:** decides if processing the event can be stopped and continued
- **EventSetup:** external service not bound to the event structure which provides information useable by all modules (e.g. Geometry, Magnetic Field, etc.)

In order to generate above modules:

- **mkedanlzr :** makes a skeleton of a package containing an [EDAnalyzer](https://twiki.cern.ch/twiki/bin/view/Main/CMSSWatFNALFramework#Module_types)
- **mkedprod :** makes a skeleton of a package containing an [EDProducer](https://twiki.cern.ch/twiki/bin/view/Main/CMSSWatFNALFramework#Module_types)
- **mkedfltr :** makes a skeleton of a package containing an [EDFilter](https://twiki.cern.ch/twiki/bin/view/Main/CMSSWatFNALFramework#Module_types)
- **mkrecord :** makes a complete implementation of a Record used by the [EventSetup](https://twiki.cern.ch/twiki/bin/view/Main/CMSSWatFNALFramework#Module_types)

More generators are available and you can find them [here](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideSkeletonCodeGenerator)

<!-- To be decided: should we bring the tutorial material to the guide? In this case, giving brief introduction here and pointing to the workshop tutorial for further information seems to be a good choice -->
The code examples provided with the CMS open data are mostly EDAnalyzers. A hands-on tutorial to learn more on CMSSW and EDAnalyzers is available in the [CMS open data workshop material](https://cms-opendata-workshop.github.io/workshop2021-lesson-cmssw/). For examples, this guide mainly refers to:

=== "Run 1 Data"

    - [Physics Objects Extractor Tool (POET)](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/tree/2012): shows how to extract physics (objects) information and gives examples of methods or tools needed for processing them. For the sake of clarity, [EDAnalyzer modules](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/tree/2012/PhysObjectExtractor/src) are provided separately for each object.
    - [AOD2NanoAODOutreachTool](https://github.com/cms-opendata-analyses/AOD2NanoAODOutreachTool/tree/2012): reads events from CMS AOD files and convert them to a reduced data format. This example provides a single [EdAnalyzer module](https://github.com/cms-opendata-analyses/AOD2NanoAODOutreachTool/blob/2012/src/AOD2NanoAOD.cc) handling all types of physics objects.

=== "Run 2 Data"

    - [Physics Objects Extractor Tool (POET)](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/tree/2015MiniAOD): shows how to extract physics (objects) information and gives examples of methods or tools needed for processing them. For the sake of clarity, [EDAnalyzer modules](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/tree/2015MiniAOD/PhysObjectExtractor/src) are provided separately for each object.
