# FAQ

Frequently Asked Questions and other problems and issues
that have come up.

***Possible subsections below***

## High-level questions

### **Why would I choose VirtualBox over docker? Why would I choose docker over VirtualBox?**

Great question! Anyone?

## Docker

### **Docker downloads container but never launches environment**

This is an issue with newer OSs on your local laptop/desktop running older OSs in the container.

For example, suppose you are following the [Running CMS analysis code using Docker](http://opendata.cern.ch/docs/cms-guide-docker)
tutorial. If you run

```bash
docker run --name opendata -it cmsopendata/cmssw_5_3_32 /bin/bash
```

and the container downloads but you don't find yourself in the ```CMSSW_5_3_32``` environment, then...

## Data

## CMSSW
