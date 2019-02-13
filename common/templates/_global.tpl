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
		{{- $host := include "common.gateway-host"  . -}}
		{{- $auth := include "common.keycloak-path" . -}}
		{{- $defaultUrl := printf "%s://%s%s" $proto $host $auth -}}
		{{- $keycloakUrl := default $defaultUrl .Values.global.keycloak.url -}}
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
{{- tpl "http{{ if (eq .Values.global.gateway.http false) }}s{{ end }}" . -}}
{{- end -}}

{{- define "common.gateway-host" -}}
{{- $value := default (include "common.gateway-domain" .) .Values.global.gateway.host -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.gateway-domain" -}}
{{- $value := default "localhost" .Values.global.gateway.domain -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.keycloak-path" -}}
{{- $value := default "/auth" .Values.global.keycloak.path -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.keycloak-host" -}}
{{- $value := default .Values.global.keycloak.host .Values.ingress.hostName -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "common.keycloak-enabled" -}}
{{- default "" .Values.global.keycloak.enabled -}}
{{- end -}}
 
