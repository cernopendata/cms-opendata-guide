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


## How to contribute

Everyone is welcome to help build and/or improve this guide. If you find a bug or want to make a suggestion, please fill out an [issue](https://github.com/cernopendata/cms-opendata-guide/issues). If you would like to contribute, there are two options depending on whether you are already a collaborator of the project or not.

### If you are a collaborator already
1. If you found a topic of your interest but there is no associated issue yet in the "To do" board of an open project, please comment on the corresponding checklist and tag one of the coordinators of the project.  The coordinator will then interact with you to create an appropiate issue in the "To do" list so you can follow the rest of the steps below.
1. If there is already an open issue, within the "To do" board of an open [project](https://github.com/cernopendata/cms-opendata-guide/projects), that you are interested in working on, you can assign it to yourself and move it to the "In progress" board. Remember that you could also move an open issue to the "Discussion" or the "Need info" boards.
1. Check whether the topic, corresponding to the issue, 
    has already a page in the file that steers the [structure of the guide](https://github.com/cernopendata/cms-opendata-guide/blob/master/mkdocs.yml).   
1. If there is no such a page, contact one of the coordinators of the project to create it for you or to agree to create it yourself.  You could just make a comment in your issue, tagging a coordinator therein, which will trigger the discussion.
1. Once the appropiate page exists, you can start writing the relevant information either directly into the repository on the webpage or (preferably) on your own, local github area.
   * **Please follow the [content guidelines](#content-guidelines)** below.
   * If working locally, feel free to test it first following the [local testing](#test-locally) instructions below.
   * Make sure to check for missing new lines at EOF and trailing white spaces.  A simple way to check is by using the `git diff` and/or `git diff --check` commands.
   * Please test locally for style issues by running the command `./run-tests.sh --check-docstyle` (Note that you might need to install [awesome_bot](https://github.com/cernopendata/cms-opendata-guide/blob/eedc8d880729c3ef69ea75c1ea38efa6216a1537/.github/workflows/ci.yml#L41))
   * When ready, push to the master branch to trigger the automatic [deployment](#deploy).
   * Please [close the issue](https://help.github.com/en/enterprise/2.16/user/github/managing-your-work-on-github/closing-issues-using-keywords#closing-multiple-issues) when done.
1. The page you are creating should, in most cases, be accompanied by a workshop tutorial lesson or exercise.  Ideally, the issue the page is addressing should point (if necessary) to the corresponding issue in the [cms-opendata-workshop](https://github.com/cms-opendata-workshop) organization.


### If you are not a collaborator yet

Make a direct [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) or (preferably) [contact us][email] first.

## Content guidelines

Please follow these simple guidelines:

* The Guide is meant to organize pieces of information already available in the [CMS CERN Open Portal](http://opendata.cern.ch/search?experiment=CMS) site, the public [CMS Twiki](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WebHome), the [CMSSW](http://cms-sw.github.io/) components, etc., in a logical way, following mainly the structure of a real physics analysis project.
* Check out the [basics for markdown](https://squidfunk.github.io/mkdocs-material/reference/). 
* **Do not** paste big code snippets into the Guide pages.
* If there is need to point to extended lines of code it is best to direct the user to the practical lessons or exercises that are implemented in the sister [cms-opendata-workshop](https://github.com/cms-opendata-workshop) organization using web links.
* The Guide **is not** supposed to be a copy of these tutorials (workshop) pages but rather an aid to navigate them.
* If differentiation between `Run 1` and `Run 2` information is required, please use [material mkdocs tabs](https://squidfunk.github.io/mkdocs-material/reference/content-tabs/#grouping-other-content) for grouping content.
* If you need an example of how the content is written, check out one of the already-written pages in the [docs](https://github.com/cernopendata/cms-opendata-guide/tree/master/docs) folder of this repository; [this one](https://raw.githubusercontent.com/cernopendata/cms-opendata-guide/master/docs/tools/docker.md), for instance.
  

## Test locally

Make sure you have installed the [virtualenv](https://virtualenv.pypa.io/en/latest/installation.html) and [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/install.html) packages. Be sure to source the included virtualenvwrapper.sh script, or add it to your path in your .bashrc. For example, if virtualenvwrapper.sh was installed in /usr/local/bin, then you could type 

```console
$ source /usr/local/bin/virtualenvwrapper.sh
```

You may need to set the variable VIRTUALENVWRAPPER_PYTHON to your python path (verify it with `which python` or `which python3`) with:

```console
$ export VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3'
```

Once you have the virtualenvwrapper installed, you can list your virtual environments by typing ```workon```

If this is your first virtual environment, when you type ```workon```, the output will be empty. But, after installing one (as you will below), you will be able to choose it from the list. For example if you create a virtual environment called cms-opendata-guide, you can work in that environment by typing 

``` console
$ workon cms-opendata-guide
```

You can create a virtual environment called cms-data-guide, install dependencies via pip, start up a mkdocs server, and then open a local browser by:

```console
$ mkvirtualenv cms-opendata-guide
$ pip install -r requirements.txt
$ mkdocs serve
$ firefox http://127.0.0.1:8000
```
You can exit from the virtual environment with `deactivate`.

You can run local tests executing `./run-tests.sh`. Testing requires [a ruby installation](https://www.ruby-lang.org/en/documentation/installation/). You will also need to install the ruby gem `awesome_bot` by issuing `gem install awesome_bot` and make sure that gem in accessible on your path.  In addition, `npx` is also required by the test script.  For this one should install `nodejs` and `npm`, and install it using the node package manager (npm) as `npm i npx`.   

### Note on markdown

Markdownlint is used to check your markdown. However, it does not allow inline HTML. To temporarily allow it, you can wrap your inline HTML as follows:
``` console
<!-- markdownlint-disable -->
write your inline HTML code here
<!-- markdownlint-restore -->
```

## Deploy

Documentation site is deployed on [OpenShift](https://openshift.cern.ch/).

Once a new commit is pushed to **master**, OpenShift will automatically trigger a new build with the latest changes.



[email]: mailto:cms-dpoa-coordinators@cern.ch
