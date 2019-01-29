{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default service name.
*/}}
{{- define "servicename" -}}
{{- $name := default (include "fullname" .) .Values.service.name -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default tls secrtet name.
*/}}
{{- define "tlssecretname" -}}
{{- $name := default (printf "tls-%s-%s" .Release.Name "activiti-cloud-gateway")  (or .Values.ingress.tlsSecret .Values.global.gateway.ingress.tlsSecret) -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default ingress host.
*/}}
{{- define "ingresshost" -}}
{{- default .Values.global.gateway.host .Values.ingress.hostName -}}
{{- end -}}
