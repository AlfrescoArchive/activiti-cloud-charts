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
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a frontend ingress path.
*/}}
{{- define "activiti-cloud-modeling.ingress-path-frontend" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $basePath := include "common.ingress-path" . -}}
		{{- $value := tpl .Values.ingress.frontend.path . -}}
		{{- $suffix := tpl .Values.ingress.frontend.pathSuffix . -}}
		{{- tpl (printf "%s%s%s" $basePath $value $suffix) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a ws-graphql ingress path.
*/}}
{{- define "activiti-cloud-modeling.ingress-path-backend" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $basePath := include "common.ingress-path" . -}}
		{{- $value := tpl .Values.ingress.backend.path . -}}
		{{- tpl (printf "%s%s" $basePath $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default extra env templated values for backend
*/}}
{{- define "activiti-cloud-modeling.extra-env-backend" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with merge $noValues $overrides $common -}}
{{- include "common.extra-env" . -}}
{{- tpl .Values.backend.extraEnv . -}}
{{- end -}}
{{- end -}}

{{/*
Create a default extra env templated values for frontend
*/}}
{{- define "activiti-cloud-modeling.extra-env-frontend" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with merge $noValues $overrides $common -}}
{{- include "common.extra-env" . -}}
{{- tpl .Values.frontend.extraEnv . -}}
{{- end -}}
{{- end -}}

{{/* 
Create container frontend image  
*/}} 
{{- define "activiti-cloud-modeling.container-frontend-image" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- $registry := tpl .Values.frontend.image.registry . -}} 
{{- $repository := tpl .Values.frontend.image.repository . -}} 
{{- $tag := tpl .Values.frontend.image.tag . -}} 
{{- if $registry -}} {{ printf "%s/" $registry }} {{- end -}} {{ print $repository }} {{- if $tag -}} {{ printf ":%s" $tag }} {{- end -}}	 
{{- end }} 
{{- end -}} 
 
{{/* 
Create container frontend image  
*/}} 
{{- define "activiti-cloud-modeling.container-backend-image" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- $registry := tpl .Values.backend.image.registry . -}} 
{{- $repository := tpl .Values.backend.image.repository . -}} 
{{- $tag := tpl .Values.backend.image.tag . -}} 
{{- if $registry -}} {{ printf "%s/" $registry }} {{- end -}} {{ print $repository }} {{- if $tag -}} {{ printf ":%s" $tag }} {{- end -}}	 
{{- end }} 
{{- end -}} 
  