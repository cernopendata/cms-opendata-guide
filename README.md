# CMS Open Data Guide

MkDocs documentation for the [CMS Open Data Guide](https://cms-opendata-guide.web.cern.ch).

   * [The Guide's philosophy](#the-guides-philosophy)
   * [How to contribute](#how-to-contribute)
      * [If you are a collaborator already](#if-you-are-a-collaborator-already)
      * [If you are not a collborator yet](#if-you-are-not-a-collborator-yet)
   * [Test locally](#test-locally)
   * [Deploy](#deploy)




## The Guide's philosophy
The main purpose of the CMS Open Data Guide is to facilitate the understanding of the CMS open data, its tools, and their usage for research. 

The Guide is meant to organize pieces of information already available in the [CMS CERN Open Portal](http://opendata.cern.ch/search?experiment=CMS) site, the public [CMS Twiki](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WebHome), the [CMSSW](http://cms-sw.github.io/) components, etc., in a logical way, following mainly the structure of a real physics analysis project.

Therefore, the sections at the heart of this Guide should also point to practical lessons or exercises that are implemented in the sister [cms-opendata-workshop](https://github.com/cms-opendata-workshop) organization.

## How to contribute

Everyone is welcome to help build and/or improve this guide. If you find a bug or want to make a suggestion, please fill out an [issue](https://github.com/cernopendata/cms-opendata-guide/issues). If you would like to contribute, there are two options depending on whether you are already a collaborator of the project or not.

### If you are a collaborator already
1. If you found a topic of your interest but there is no associated issue yet in the "To do" board of an open project, please comment on the corresponding checklist and tag one of the coordinators of the project.  The coordinator will then interact with you to create an appropiate issue in the "To do" list so you can follow the rest of the steps below.
1. If there is already an open issue, within the "To do" board of an open [project](https://github.com/cernopendata/cms-opendata-guide/projects), that you are interested in working on, you can assign it to yourself and move it to the "In progress" board. Remember that you could also move an open issue to the "Discussion" or the "Need info" boards.
1. Check whether the topic, corresponding to the issue, 
    has already a page in the file that steers the [structure of the guide](https://github.com/cernopendata/cms-opendata-guide/blob/master/mkdocs.yml).   
1. If there is no such a page, contact one of the coordinators of the project to create it for you or to agree to create it yourself.  You could just make a comment in your issue, tagging a coordinator therein, which will trigger the discussion.
1. Once the appropiate page exists, you can start writing the relevant information either directly into the repository on the webpage or (preferably) on your own, local github area.  
   * If working locally, feel free to test it first following the [local testing](#test-locally) instructions below.
   * Make sure to check for missing new lines at EOF and trailing white spaces.  A simple way to check is by using the `git diff` and/or `git diff --check` commands.
   * Please test locally for style issues by running the command `./run-tests.sh --check-docstyle` (Note that you might need to install [awesome_bot](https://github.com/cernopendata/cms-opendata-guide/blob/eedc8d880729c3ef69ea75c1ea38efa6216a1537/.github/workflows/ci.yml#L41))
   * When ready, push to to the master branch to trigger the automatic [deployment](#deploy).
   * Please [close the issue](https://help.github.com/en/enterprise/2.16/user/github/managing-your-work-on-github/closing-issues-using-keywords#closing-multiple-issues) when done.
1. The page you are creating should, in most cases, be accompanied by a workshop tutorial lesson or exercise.  Ideally, the issue the page is addressing should point (if necessary) to the corresponding issue in the [cms-opendata-workshop](https://github.com/cms-opendata-workshop) organization.


### If you are not a collaborator yet

Make a direct [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) or (preferably) [contact us][email] first.


## Test locally

Make sure you have installed virtualenv and virtualenvwrapper packages.

```console
$ mkvirtualenv cms-opendata-guide
$ pip install -r requirements.txt
$ mkdocs serve
$ firefox http://127.0.0.1:8000
```

## Deploy

Documentation site is deployed on [OpenShift](https://openshift.cern.ch/).

Once a new commit is pushed to **master**, OpenShift will automatically trigger a new build with the latest changes.



[email]: mailto:cms-dpoa-coordinators@cern.ch
