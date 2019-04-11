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
Create a actuator ingress path.
*/}}
{{- define "activiti-cloud-notifications-graphql.ingress-path-actuator" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $basePath := include "common.ingress-path" . -}}
		{{- $value := tpl .Values.ingress.actuator.path  . -}}
		{{- tpl (printf "%s%s" $basePath $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a graphiql ingress path.
*/}}
{{- define "activiti-cloud-notifications-graphql.ingress-path-graphiql" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $basePath := include "common.ingress-path" . -}}
		{{- $value := tpl .Values.ingress.graphiql.path . -}}
		{{- tpl (printf "%s%s" $basePath $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a web ingress path.
*/}}
{{- define "activiti-cloud-notifications-graphql.ingress-path-web" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $basePath := include "common.ingress-path" . -}}
		{{- $value := tpl .Values.ingress.web.path . -}}
		{{- tpl (printf "%s%s" $basePath $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a ws-graphql ingress path.
*/}}
{{- define "activiti-cloud-notifications-graphql.ingress-path-ws-graphql" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $basePath := include "common.ingress-path" . -}}
		{{- $value := tpl .Values.ingress.ws.path . -}}
		{{- tpl (printf "%s%s" $basePath $value) . -}}
	{{- end -}}
{{- end -}}

