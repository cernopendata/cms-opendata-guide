# Overview

The overall collection of software, referred to as CMS Software (CMSSW), is built around a Framework, an Event Data Model (EDM), and Services needed by the simulation, calibration and alignment, and reconstruction modules that process event data so that physicists can perform analysis. The primary goal of the Framework and EDM is to facilitate the development and deployment of reconstruction and analysis software.

The CMSSW event processing model consists of one executable, called `cmsRun`, and many plug-in modules which are managed by the Framework. All the code needed in the event processing (calibration, reconstruction algorithms, etc.) is contained in the modules. The same executable is used for both detector and Monte Carlo data. More and detailed information can be found [here](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookCMSSWFramework).
