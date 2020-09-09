# Virtual machines

  CMS open data and legacy data, even though still exciting and full of potential, are already a few years old.  Because of the rapidly evolving technolgies, the computing environments that were used to analyze these data are already ancient compared to the current, bleeding edge ones.  

Therefore, in order to mantain our ability to study these data, we have to rely on technologies that help us preserve adequate computer environments.  One way of doing this is by using virtual machines.

In simple words, a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) is an emulation of a computer system that can run within another system.  The latter is usually known as the host.

### Open data versions, CMSSW and operating systems

CMS open data from our 2010 release can be studied using CMSSW_4_2_8, a version of the [CMSSW](https://cms-opendata-guide.web.cern.ch/#cmssw) software that used to run under Scientific Linux CERN 5 (slc5) operating system.  Likewise, open data from our 2011/2012 release used CMSSW_5_3_32 under Scientific Linux CERN 6 (slc6). 

The virtual machines that are used to analyze these data, therefore, need to consider all these compatibility features. 

### Virtual machine images

In practical terms, a virtual machine image is a computer file that has all the right ingredients to create a virtual computer inside a given host.  This file, however, needs to be *decoded* by a virtual machine interpreter, usually known as [hypervisor](https://en.wikipedia.org/wiki/Hypervisor), which runs on the host machine.  One of the most famous hypervisors is Oracle's [VirtualBox](https://en.wikipedia.org/wiki/VirtualBox).

### CMS virtual images

The most current images for CMS open data usage are described separately in the CERN Open Portal site for [2010](http://opendata.cern.ch/record/250) and [2011/2012](http://opendata.cern.ch/record/252).

!!! Note   
    When installing a CMS virtual machine (following the [instructions](#installation) below), always use the latest image file available for [2010](http://opendata.cern.ch/record/250) or [2011/2012](http://opendata.cern.ch/record/252) data.

### Installation



