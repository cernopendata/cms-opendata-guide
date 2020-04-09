# cms-opendata-guide
MkDocs documentation for the Open Data guide: https://cms-opendata-guide.web.cern.ch

## Test locally

```console
$ mkvirtualenv cms-opendata-guide
$ pip install -r requirements.txt
$ mkdocs serve
$ firefox http://127.0.0.1:8000
```

## Deploy

Documentation site is deployed on [OpenShift](https://openshift.cern.ch/).

Once a new commit is pushed to **master**, OpenShift will automatically trigger a new build with the latest changes.
