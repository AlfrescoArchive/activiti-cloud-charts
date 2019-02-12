{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name for the keycloak requirement.
*/}}
{{- define "activiti.keycloak.fullname" -}}
{{- $keycloakContext := dict "Values" .Values.keycloak "Release" .Release "Chart" (dict "Name" "keycloak") -}}
{{ template "keycloak.fullname" $keycloakContext }}
{{- end -}}

{{/*
Create a default name for the keycloak requirement.
*/}}
{{- define "activiti.keycloak.name" -}}
{{- $keycloakContext := dict "Values" .Values.keycloak "Release" .Release "Chart" (dict "Name" "keycloak") -}}
{{ template "keycloak.name" $keycloakContext }}
{{- end -}}
