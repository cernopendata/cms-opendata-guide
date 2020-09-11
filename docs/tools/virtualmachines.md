# Virtual machines

CMS open data and legacy data, even though still exciting and full of potential, are already a few years old.  Because of the rapidly evolving technolgies, the computing environments that were used to analyze these data are already ancient compared to the current, bleeding edge ones.

Therefore, in order to mantain our ability to study these data, we have to rely on technologies that help us preserve adequate computer environments.  One way of doing this is by using virtual machines.

In simple words, a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) is an emulation of a computer system that can run within another system.  The latter is usually known as the *host*.

## Open data releases, CMSSW versions and operating systems

CMS open data from our 2010 release can be studied using CMSSW_4_2_8, a version of the [CMSSW](../../cmssw/cmsswoverview) software that used to run under Scientific Linux CERN 5 (slc5) operating system.  Likewise, open data from our 2011/2012 release used CMSSW_5_3_32 under Scientific Linux CERN 6 (slc6).

The virtual machines that are used to analyze these data, therefore, need to consider all these compatibility subtleties.

## Virtual machine images

In practical terms, a virtual machine image is a computer file that has all the right ingredients to create a virtual computer inside a given host.  This file, however, needs to be *decoded* by a virtual machine interpreter, usually known as [hypervisor](https://en.wikipedia.org/wiki/Hypervisor), which runs on the host machine.  One of the most famous hypervisors is Oracle's [VirtualBox](https://en.wikipedia.org/wiki/VirtualBox).

## CMS virtual images

The most current images for CMS open data usage are described separately in the CERN Open Portal site for [2010](http://opendata.cern.ch/record/250) and [2011/2012](http://opendata.cern.ch/record/252).  They come equiped with the [ROOT](http://root.cern.ch/) framework, [CMSSW](http://cms-sw.github.io/) and [CVMFS](https://cvmfs.readthedocs.io/en/stable/index.html) access.

!!! Note "Remember"
    When installing a CMS virtual machine (following the [instructions](#installation) below), always use the latest image file available for [2010](http://opendata.cern.ch/record/250) or [2011/2012](http://opendata.cern.ch/record/252) data.

## Installation

Detailed instructions on how to install the CERN virtual machines can be found in the [2010](http://opendata.cern.ch/docs/cms-virtual-machine-2010) and [2011/2012](http://opendata.cern.ch/docs/cms-virtual-machine-2011) virtual machine installation guides from the CERN Open Portal.  Choose the one to follow depending on the data release you will be working on.

In summary, the basic steps are as follows:

- Download and install the latest (or even better, the latest tested) version of [VirtualBox](https://www.virtualbox.org/wiki/Downloads).  Note that it is available for an ample range of platforms.
- Download the **latest** CMS virtual image file.  Choose between [2010](http://opendata.cern.ch/docs/cms-virtual-machine-2010#downloading-and-creating-a-virtual-machine) or [2011/2012](http://opendata.cern.ch/docs/cms-virtual-machine-2011#downloading-and-creating-a-virtual-machine), depending on the data release of interest. Once downloaded, import the image file into VirtualBox.

    !!! Note "Remember"
        Always use the latest image file available for [2010](http://opendata.cern.ch/record/250) or [2011/2012](http://opendata.cern.ch/record/252). Older ones are usually deprecated.

- Test the environment; again, [2010](http://opendata.cern.ch/docs/cms-virtual-machine-2010#step-2-how-to-test-validate) or [2011/2012](http://opendata.cern.ch/docs/cms-virtual-machine-2011#step-2-how-to-test-validate), depending on the release.
- Finally, check for any known issues or limitations ([2010](http://opendata.cern.ch/docs/cms-virtual-machine-2010#known-issues-limitations), [2011/2012](http://opendata.cern.ch/docs/cms-virtual-machine-2011#known-issues-limitations).)