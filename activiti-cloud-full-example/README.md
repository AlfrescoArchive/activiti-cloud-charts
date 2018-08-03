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

You will need to be able expose services externally. The activiti install process is simpler if services are exposed with a wildcard DNS and the DNS is mapped to an ingress in advance of the install. This available out of the box with Jenkins-X. You may also have this on your cluster already if you have an Ingress controller and wildcard DNS mapped to it (e.g. Route53). We suggest installing an nginx ingress controller and using the free, public nip.io service for DNS. This should work for most platforms.

## Jenkins X Users
If you use Jenkins-X you can get your DNS name by doing
```
jx env dev
jx get urls
```
You’ll see url of the form http://jenkins.jx.<CLUSTER_IP>. You can then skip to `Activiti Example Installation`

## Installing Ingress
You can install the nginx ingress controller with helm:

```helm install stable/nginx-ingress```

Once you get your Ingress Controller up and running you will need to get its external IP address, and you can use a service such as [nip.io](http://nip.io) as DNS service. This will allow you to access your services by name under the same domain.

In order to get the Ingress Controller external IP you can run:
> kubectl get service

You will need to copy the EXTERNAL-IP from your controller and now you can use NIP.io by pointing to your services at:
```<SERVICE-NAME>.<EXTERNAL-IP>.nip.io```

# Activiti Example Installation
Before installing the Activiti example chart you will need to provide a values.yaml file (myvalues.yaml) which you can copy from the file in this directory and update with your DNS name. Look for <DNS name> inside the values.yaml file and replace accordingly with your DNS.

You can install this chart by running against a Kubernetes Cluster:

```
helm repo add activiti-cloud-charts https://activiti.github.io/activiti-cloud-charts/
helm repo update
helm install -f myvalues.yaml activiti-cloud-charts/activiti-cloud-full-example
```


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
