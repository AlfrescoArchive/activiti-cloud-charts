#activiti-cloud-audit 1.1.6
#activiti-cloud-connector 1.1.5
#activiti-cloud-gateway 1.1.6
#activiti-cloud-modeling 1.1.7
#activiti-cloud-notifications-graphql 1.1.6
#activiti-cloud-query 1.1.6
#activiti-keycloak 1.1.4
#runtime-bundle 1.1.6

#common 1.1.2

#application 1.1.5
#infrastructure 1.1.5


chartname=$1
echo $chartname
version=$(echo -n ` awk -F'version: ' '{print $2}' $chartname/Chart.yaml`)
echo $version
newversion=$(echo $version | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
echo $newversion

perl -i -pe"s/version:\ $version/version:\ $newversion/g" $chartname/Chart.yaml

rm $chartname/requirements.lock
helm dep build $chartname 
helm lint $chartname
helm package $chartname
mv $chartname*.tgz docs
git add $chartname/Chart.yaml
git add docs/$chartname-$newversion.tgz
