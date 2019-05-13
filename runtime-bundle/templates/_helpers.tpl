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
Create init container image  
*/}} 
{{- define "runtime-bundle.init-container-image" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- $registry := tpl .Values.init.image.registry . -}} 
{{- $repository := tpl .Values.init.image.repository . -}} 
{{- $tag := tpl (toString .Values.init.image.tag) . -}} 
{{- if $registry -}} {{ printf "%s/" $registry }} {{- end -}} {{ print $repository }} {{- if $tag -}} {{ printf ":%s" $tag }} {{- end -}}	 
{{- end }} 
{{- end -}} 
 

{{/* 
Create init container image  
*/}} 
{{- define "runtime-bundle.init-container-image-pull-policy" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- tpl .Values.init.image.pullPolicy . -}} 
{{- end }} 
{{- end -}} 
 