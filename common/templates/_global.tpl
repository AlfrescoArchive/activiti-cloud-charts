{{/* vim: set filetype=mustache: */}}
{{/*
Create a keycloak url template
*/}}
{{- define "common.keycloak-url" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $proto := include "common.gateway-proto" . -}}
		{{- $host := include "common.keycloak-host" . -}}
		{{- $path := include "common.keycloak-path" . -}}
		{{- $url := printf "%s://%s%s" $proto $host $path -}}
		{{- $keycloakUrl := default $url .Values.global.keycloak.url -}}
		{{- tpl (printf "%s" $keycloakUrl ) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a gateway url template
*/}}
{{- define "common.gateway-url" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $proto := include "common.gateway-proto" . -}}
		{{- $host := include "common.gateway-host"  . -}}
		{{- $gatewayUrl := printf "%s://%s" $proto $host -}}
		{{- tpl $gatewayUrl . -}}
	{{- end -}}
{{- end -}}

{{- define "common.gateway-proto" -}}
{{- $http := toString .Values.global.gateway.http -}}
{{- if eq $http "false" }}https{{else}}http{{ end -}}
{{- end -}}

{{- define "common.gateway-https-enabled" -}}
{{- $http := toString .Values.global.gateway.http -}}
{{- default "" (eq $http "false") -}}
{{- end -}}

{{- define "common.gateway-host" -}}
{{- $value := default (include "common.gateway-domain" .) .Values.global.gateway.host -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.gateway-domain" -}}
{{- $value := default "" .Values.global.gateway.domain -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.keycloak-path" -}}
{{- $value := default "/auth" .Values.global.keycloak.path -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.keycloak-host" -}}
{{- $value := default (include "common.gateway-host" .) .Values.global.keycloak.host -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.keycloak-enabled" -}}
{{- default "" .Values.global.keycloak.enabled -}}
{{- end -}}
 
{{/*
Create default pull secrets
*/}}
{{- define "common.registry-pull-secrets" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- $values := merge $noValues $overrides $common -}} 
{{- with $values -}}
{{- range $value := .Values.global.registryPullSecrets }}
- name: {{ tpl (printf "%s" $value) $values | quote }}
{{- end }}
{{- range $value := .Values.registryPullSecrets }}
- name: {{ tpl (printf "%s" $value) $values | quote }}
{{- end }}

{{- end }}
{{- end -}}

{{/*
Create container image 
*/}}
{{- define "common.container-image" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with  merge $noValues $overrides $common -}} 
{{- $registry := include "common.container-image-registry" . -}}
{{- $repository := include "common.container-image-repository" . -}}
{{- $tag := include "common.container-image-tag" . -}}
{{- if $registry -}} {{ printf "%s/" $registry }} {{- end -}} {{ print $repository }} {{- if $tag -}} {{ printf ":%s" $tag }} {{- end -}}	
{{- end }}
{{- end -}}

{{/*
Create container image pullPolicy
*/}}
{{- define "common.container-image-pull-policy" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with  merge $noValues $overrides $common -}} 
{{  tpl .Values.image.pullPolicy . | default "IfNotPresent"}}
{{- end }}
{{- end -}}

{{/*
Create container image registry
*/}}
{{- define "common.container-image-registry" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with  merge $noValues $overrides $common -}} 
{{  tpl .Values.image.registry . | default "" }}
{{- end }}
{{- end -}}

{{/*
Create container image tag
*/}}
{{- define "common.container-image-tag" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with  merge $noValues $overrides $common -}} 
{{  tpl (toString .Values.image.tag) . | default "" }}
{{- end }}
{{- end -}}

{{/*
Create container image repository
*/}}
{{- define "common.container-image-repository" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with  merge $noValues $overrides $common -}} 
{{  tpl .Values.image.repository . }}
{{- end }}
{{- end -}}

{{/* 
Create init container image  
*/}} 
{{- define "common.init-container-image" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- $registry := include "common.init-container-registry" . -}} 
{{- $repository := include "common.init-container-repository" . -}} 
{{- $tag := include "common.init-container-tag" . -}} 
{{- if $registry -}} {{ printf "%s/" $registry }} {{- end -}} {{ print $repository }} {{- if $tag -}} {{ printf ":%s" $tag }} {{- end -}}	 
{{- end }} 
{{- end -}} 

{{/* 
Create init container image pull policy
*/}} 
{{- define "common.init-container-image-pull-policy" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- tpl .Values.init.image.pullPolicy . | default "IfNotPresent" -}} 
{{- end }} 
{{- end -}} 

{{/* 
Create init container registry  
*/}} 
{{- define "common.init-container-registry" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- tpl .Values.init.image.registry . | default "" -}} 
{{- end }} 
{{- end -}}  

{{/* 
Create init container repository  
*/}} 
{{- define "common.init-container-repository" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- tpl .Values.init.image.repository . | default "" -}} 
{{- end }} 
{{- end -}}  

{{/* 
Create init container tag  
*/}} 
{{- define "common.init-container-tag" -}} 
{{- $common := dict "Values" .Values.common -}}  
{{- $noCommon := omit .Values "common" -}}  
{{- $overrides := dict "Values" $noCommon -}}  
{{- $noValues := omit . "Values" -}}  
{{- with  merge $noValues $overrides $common -}}  
{{- tpl (toString .Values.init.image.tag) . | default "" -}} 
{{- end }} 
{{- end -}}  

{{/*
Create a default keycloak realm
*/}}
{{- define "common.keycloak-realm" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $value := .Values.global.keycloak.realm -}}
		{{- tpl (printf "%s" $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default keycloak resource
*/}}
{{- define "common.keycloak-resource" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $value := .Values.global.keycloak.resource -}}
		{{- tpl (printf "%s" $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default keycloak client
*/}}
{{- define "common.keycloak-client" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $value := .Values.global.keycloak.client -}}
		{{- tpl (printf "%s" $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default extra env templated values 
*/}}
{{- define "common.extra-env" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- with merge $noValues $overrides $common -}}
{{- tpl .Values.global.keycloak.extraEnv . -}}
{{- tpl .Values.global.extraEnv . -}}
{{- tpl .Values.extraEnv . -}}
{{- end -}}
{{- end -}}

