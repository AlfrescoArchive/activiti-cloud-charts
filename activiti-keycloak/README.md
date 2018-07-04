# Activiti Keycloak

Uses the official keycloak chart but not currently the latest version as the realm configuration has not yet been tested on keycloak 4.

To use without exposecontroller then the following script should be configured with your UI urls on the right:

```$yaml
    preStartScript: |
      cp /realm/activiti-realm.json .
      sed -i 's/activiti-cloud-demo-ui:30082/jx-staging-quickstart-http.jx-staging.activiti.envalfresco.com/g' activiti-realm.json
      sed -i 's/activiti-cloud-demo-ui:\*/jx-staging-quickstart-http.jx-staging.activiti.envalfresco.com:*/g' activiti-realm.json
      sed -i 's/placeholder.com/jx-staging-quickstart-http.jx-staging.activiti.envalfresco.com:*/g' activiti-realm.json
      sed -i 's/dummy.com/gw.jx-staging.activiti.envalfresco.com:*/g' activiti-realm.json
      sed -i 's/activiti-cloud-sso-idm-kub:30082/gw.jx-staging.activiti.envalfresco.com/g' activiti-realm.json
      sed -i 's/activiti-cloud-demo-ui:3000/activiti-cloud-demo-ui.jx-staging.activiti.envalfresco.com/g' activiti-realm.json
```

This will override the dummy values and make add your external urls as redirectUris and allowed origins in the keycloak realm.

If your k8s cluster has the exposecontroller then you can use extraEnv to inject urls from configmaps as environment variables.