# Activiti Cloud Application Full example chart

This example includes all the building blocks that conforms an Activiti Cloud application, such as:

- Gateway (Spring Cloud)
- SSO/IDM (Keycloak)
- Activiti Cloud Runtime Bundle (Example)
- Activiti Cloud Connector (Example)
- Activiti Cloud Query Service
- Activiti Cloud Audit Service

![Example](https://github.com/Activiti/activiti-cloud-charts/blob/master/resources/images/activiti-cloud-full-example-chart.png)

# Prerequisites

You will need to be able expose services from your kubernetes cluster externally. The activiti example install process is simpler if services are exposed with a wildcard DNS and the DNS is mapped to an ingress in advance of the install. This available out of the box with Jenkins-X. You may also have this on your cluster already if you have an Ingress controller and wildcard DNS mapped to it (e.g. Route53). We suggest installing an nginx ingress controller and using the free, public nip.io service for DNS. This should work for most platforms.

There are several places where the external DNS or IP need to be set. The easiest way to do this is to copy-paste the contents of the values.yaml here to create a local file (e.g. 'myvalues.yaml') and modify or find-replace in that file. The helm install can then be done with the -f option to use that file.

## Jenkins X Users
If you use Jenkins-X you can get your DNS name by doing
```
jx env dev
jx get urls
```
You’ll see url of the form http://jenkins.jx.<CLUSTER_IP>. You can then skip to `Activiti Example Installation`. But note that in jenkins-x you'll likely not use `helm install`. Instead you'll add the `helm repo add` command to the staging environment's Makefile and this chart should be added to the requirements.yaml. The values (as modified in `Activiti Example Installation`) then go in the values.yaml of the staging environment.

## Running Locally

In a local Kubernetes environment, such as is provided by *minikube* or *Docker Desktop*, you don't need an ingress.  Instead you can set the Keycloak and API Gateway to use NodePort.  To make this change, add a *type* and *nodePort* property to these services in your values.yaml file, as illustrated in these code snippets.
```
  ...
  activiti-keycloak:
    keycloak:
      enabled: true
      keycloak:
        service:
          type: NodePort
          nodePort: 30100
          ...
      activiti-cloud-gateway:
        service:
          type: NodePort
          nodePort: 30101
          ...     
```
Also, be sure to set the keycloak url in the values.yaml to match the host ip and port. For minikube use the minikube ip, which can be found from `minikube dashboard`. For docker for desktop get the IP from `kubectl describe node docker-for-desktop`.

When you start minikube you can allow extra resources e.g. ```minikube start --memory 8000 --cpus 4```.  Similarly in Docker Desktop, you can allocate memory, cpu's and swap using the Preferences dialog.  

Then run the helm commands from `Activiti Example Installation` but do not perform any DNS name replacement as you need to replace all the same values with ip and port combinations instead. After installing, check the pods come up with `kubectl get pods` and go to `Interacting with the services`.

## Installing Ingress
You can install the nginx ingress controller with helm:

```helm install stable/nginx-ingress```

## Installing Ingress on AWS 

```helm install stable/nginx-ingress --set controller.scope.enabled=true --set controller.config.ssl-redirect=false```

**Only for AWS***

Replace full url for keyclock: ```i.e http://activiti-keycloak.REPLACEME/auth``` with ```http://<DNS/auth```

Replace full url for Ingress Host: ```activiti-keycloak.REPLACEME``` with ```http://<DNS```

Replace full url for activiti-cloud-gateway: ```activiti-cloud-gateway.REPLACEME``` with ```http://<DNS>```
      
### Get ELB IP and copy it for linking the ELB in AWS Route53:

```bash
export ELBADDRESS=$(kubectl get services $AMSRELEASE-nginx-ingress-controller --namespace=$DESIREDNAMESPACE -o jsonpath={.status.loadBalancer.ingress[0].hostname})
echo $ELBADDRESS
```

### Create a Route 53 Record Set in your Hosted Zone

* Go to **AWS Management Console** and open the **Route 53** console.
* Click **Hosted Zones** in the left navigation panel, then **Create Record Set**.
* In the **Name** field, enter your "`$ELB_CNAME`" defined in step 4.
* In the **Alias Target**, select your ELB address ("`$ELBADDRESS`").
* Click **Create**.

You may need to wait a couple of minutes before the record set propagates around the world.

**Notice that you might need to configure a Service Account and a Role Binding for HELM if you haven't done so:
https://medium.com/google-cloud/helm-on-gke-cluster-quick-hands-on-guide-ecffad94b0 **

Once you get your Ingress Controller up and running you will need to get its external IP address, and you can use a service such as [nip.io](http://nip.io) as DNS service. This will allow you to access your services by name under the same domain.

In order to get the Ingress Controller external IP you can run:
> kubectl get service

![Screenshot](https://github.com/Activiti/activiti-cloud-charts/blob/master/resources/images/kubectl-get-service.jpg)

You will need to copy the EXTERNAL-IP from your controller and now you can use NIP.io by pointing to your services at:
```<SERVICE-NAME>.<EXTERNAL-IP>.nip.io```



# Activiti Example Installation
Before installing the Activiti example chart you will need to provide a values.yaml file (myvalues.yaml) which you can copy from the file in this directory and update with your DNS name. Look for \<REPLACEME\> inside the values.yaml file and replace accordingly with your DNS.

You can install this chart by running against a Kubernetes Cluster:

```
helm repo add activiti-cloud-charts https://activiti.github.io/activiti-cloud-charts/
helm repo update
helm install -f myvalues.yaml activiti-cloud-charts/activiti-cloud-full-example
```

# Upgrading the helm release
If any change in myvalues.yaml is required, there is no need to delete the helm release and start the process again. You can easily run:
> helm upgrade <release-name> activiti-cloud-charts/activiti-cloud-full-example --reuse-values -f myvalues.yaml

# Interacting with the services

You can use a postman collection to explore the example. Download https://github.com/Activiti/activiti-cloud-examples/blob/master/Activiti%20v7%20REST%20API.postman_collection.json and import the collection into your postman (we recommend installing the app and not using the chrome one). Set the value of the gateway to http://activiti-cloud-gateway.<SPECIFIC_TO_YOUR_CLUSTER> and idm to http://activiti-keycloak.<SPECIFIC_TO_YOUR_CLUSTER>

Call the refresh endpoint in gateway to refresh it.
Call the getKeycloakToken endpoint to get a keycloak token.
Call startProcess to start a process instance.
Call queryProcessInstances in query to check that query can see the process instance. Call getEvents in audit to check that the event was audited. You should also see this process instance in the UI that you checked in iv.

The example is a starting-point - plug in your images if you have them and add further runtime-bundles and connectors to customise.

# Other configurations

There is a flag in the values.yaml to enable a demo ui if desired and commented sections that can be uncommented to enable security policies.

To enable postgres rather than h2 set db.deployPostgres. See individual charts for more options.

If you don't want to use DNS then remove the Ingresses and instead set the Services to type LoadBalancer. It would then be necessary to deploy to find out the IPs and then update the values.yaml after you've found out the IPs (from kubectl get services) and update the helm release with `helm upgrade`.
