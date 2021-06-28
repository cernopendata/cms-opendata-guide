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

!!! Warning
    This page is under construction
