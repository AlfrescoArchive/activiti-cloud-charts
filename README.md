# THIS REPO IS DEPRECATED 

All chart archives are stored in https://github.com/Activiti/activiti-cloud-helm-charts
<br>Full chart located at https://github.com/Activiti/activiti-cloud-full-chart
<br>Common chart is a base chart for all charts now located at https://github.com/Activiti/activiti-cloud-common-chart
<br>Charts for components located at component folders like: runtime https://github.com/Activiti/example-runtime-bundle/tree/master/charts/runtime-bundle and 
example cloud connector https://github.com/Activiti/example-cloud-connector/tree/master/charts/activiti-cloud-connector



# activiti-cloud-charts - Helm Charts for Activiti Cloud Apps

Charts repository based on https://github.com/technosophos/tscharts.

The top-level directories are the source of the charts, except for /docs/. That hosts the packaged files as a github pages site at https://activiti.github.io/activiti-cloud-charts/.

These charts aim to follow guidance from https://github.com/kubernetes/charts/blob/master/REVIEW_GUIDELINES.md but do not do so yet and are also targeted at Jenkins-X.

### How It Works

I set up GitHub Pages to point to the `docs` folder. From there, I can
create and publish docs like this:

```console
$ helm create mychart
$ helm package mychart
$ mv mychart-0.1.0.tgz docs
$ helm repo index docs --url https://activiti.github.io/activiti-cloud-charts/
$ git add -i
$ git commit -av
$ git push origin master
```
For a chart with dependencies, do `helm dep build` before `helm package`. If the dependencies are in this repo and they are changing then bump version and push them first.

To use a chart (or build a dep with it) do `helm repo add activiti-cloud-charts https://activiti.github.io/activiti-cloud-charts/` (e.g. in Jenkins-X this would go in the Makefile).

Sample images for these charts are hosted at https://hub.docker.com/u/activiti/.

### How to get started with Activiti Cloud

See the activiti-cloud-full-example chart's README
