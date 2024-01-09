# Configuration

A configuration document, written using the Python language, is used to configure the cmsRun executable. A Python configuration program specifies which modules, inputs, outputs and services are to be loaded during execution, how to configure these modules and services, and in what order to execute them. More information can be found at the [CMS software guide](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideAboutPythonConfigFile).

The hands-on tutorial on CMSSW available in the CMS open data workshop material includes a detailed lesson on [CMSSW configuration files](https://cms-opendata-workshop.github.io/workshop2021-lesson-cmssw/05_configuration/index.html).

The configuration files for the examples that this guide mainly refers to can be found in:

=== "Run 1 Data"

    - [Physics Objects Extractor Tool (POET) configuration file](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2012/PhysObjectExtractor/python/poet_cfg.py): a single configuration file where options to process data or MC (or other processing algorithm choices) is done through input arguments.
    - AOD2NanoAODOutreachTool configuration files for [data](https://github.com/cms-opendata-analyses/AOD2NanoAODOutreachTool/blob/2012/configs/data_cfg.py) and [MC](https://github.com/cms-opendata-analyses/AOD2NanoAODOutreachTool/blob/2012/configs/simulation_cfg.py).

=== "Run 2 Data"

    - [Physics Objects Extractor Tool (POET) configuration file](https://github.com/cms-opendata-analyses/PhysObjectExtractorTool/blob/2015MiniAOD/PhysObjectExtractor/python/poet_cfg.py): a single configuration file where options to process data or MC (or other processing algorithm choices) is done through input arguments.
