# Conditions

This page explains the use of global tags and the condition database with the CMS Open Data. All information was taken from [here](http://opendata.cern.ch/docs/cms-guide-for-condition-database).

A Global Tag is a coherent collection of records of additional data needed by the reconstruction and analysis software.
The Global Tag is defined for each data-taking period, separately for collision and simulated data.

These records are stored in the condition database. Condition data include non-event-related information (Alignment, Calibration, Temperature, etc.) and parameters for the simulation/reconstruction/analysis software. For CMS Open Data, the condition data are provided as sqlite files in the `/cvmfs/cms-opendata-conddb.cern.ch/` directory, which is accessible through the CMS Open Data VM.

Most [physics objects](http://opendata.cern.ch/docs/cms-physics-objects-2011) such as `electrons`, `muons`, `photons` in the CMS Open Data are already calibrated and ready-to-use, and no additional corrections are needed other than selection and identification criteria, which will be applied in the analysis code. Therefore, simple analyses do not need to access the condition database. For example you can check [the Higgs analysis example](http://opendata.cern.ch/record/5500).

However, access to the condition database is necessary, for example, for jet energy corrections and trigger configuration information. Examples of such analyses are for [the PAT object production](http://opendata.cern.ch/record/233) or [the top quark pair production](http://opendata.cern.ch/record/5000).

Note that when you need to access the condition database, the first time you run the job on the CMS Open Data VM, it will download the condition data from the `/cvmfs` area. It will take time (an example run of a 10 Mbps line took 45 mins), but it will only happen once as the files will be cached on your VM. The job will not produce any output during this time, but you can check the ongoing processes with the command 'top' and you can monitor the progress of reading the condition data to the local cache with the command 'df'.

**Collision data and Monte Carlo data sets can be found at [http://opendata.cern.ch/docs/cms-guide-for-condition-database](http://opendata.cern.ch/docs/cms-guide-for-condition-database) for years 2010, 2011 and 2012.**

!!! Warning
    This page is under construction
