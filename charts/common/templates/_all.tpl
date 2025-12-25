{{/*
Main entrypoint for the common library chart. It will render all underlying templates based on the provided values.
*/}}
{{- define "common.all" -}}
  {{- /* Merge the local chart values and the common chart defaults */ -}}
  {{- include "common.values.setup" . }}

  {{ include "common.configmap" . | nindent 0 }}

  {{- /* Build the templates */ -}}
  {{- include "common.pvc" . }}


  {{- /* Build the templates */ -}}
  {{- include "common.pv" . }}

  {{- if .Values.serviceAccount.create -}}
    {{- include "common.serviceAccount" . }}
  {{- end -}}

  {{- if .Values.controller.enabled }}
    {{- if eq .Values.controller.type "deployment" }}
      {{- include "common.deployment" . | nindent 0 }}
    {{ else if eq .Values.controller.type "daemonset" }}
      {{- include "common.daemonset" . | nindent 0 }}
    {{ else if eq .Values.controller.type "statefulset"  }}
      {{- include "common.statefulset" . | nindent 0 }}
    {{ else if eq .Values.controller.type "cronjob"  }}
      {{- include "common.cronjob" . | nindent 0 }}
    {{ else if eq .Values.controller.type "scaledjob"  }}
      {{- include "common.scaledjob" . | nindent 0 }}
    {{ else }}
      {{- fail (printf "Not a valid controller.type (%s)" .Values.controller.type) }}
    {{- end -}}
  {{- end -}}

  {{ include "common.classes.hpa" . | nindent 0 }}

  {{ include "common.service" . | nindent 0 }}

  {{ include "common.serviceexport" . | nindent 0 }}

  {{ include "common.ingress" .  | nindent 0 }}

  {{- if .Values.serviceMonitor.enabled -}}
    {{- include "common.serviceMonitor" . }}
  {{- end -}}

  {{- if .Values.secret -}}
    {{ include "common.secret" .  | nindent 0 }}
  {{- end -}}

  {{- if and .Values.backendconfig.enabled (eq .Values.backendconfig.type "ingress") }}
    {{ include "common.backendconfigIngress" .  | nindent 0 }}
  {{- end -}}

  {{- if and .Values.backendconfig.enabled (eq .Values.backendconfig.type "gateway") }}
    {{ include "common.backendconfigGateway" .  | nindent 0 }}
  {{- end -}}

  {{ if .Values.pdb.enabled }}
    {{ include "common.pdb" . | nindent 0 }}
  {{ end }}

  {{ if .Values.alertRules }}
    {{ include "chart.alerts" . | nindent 0 }}
  {{ end }}

  {{ if .Values.alerts }}
    {{ include "chart.alertsPrometheus" . | nindent 0 }}
  {{ end }}

  {{ if or .Values.serviceAccount.roleRules (.Values.serviceAccount.role) }}
    {{ include "common.clusterrolebinding" . | nindent 0 }}
  {{ end }}

  {{ if  .Values.serviceAccount.roleRules }}
    {{ include "common.clusterrole" . | nindent 0 }}
  {{ end }}

  {{ if  .Values.scaledObject.enabled }}
    {{ include "common.scaledObject" . | nindent 0 }}
  {{ end }}

  {{ if  .Values.l4gkelb.enabled }}
    {{ include "common.l4gkelb" . | nindent 0 }}
  {{ end }}

  {{ if .Values.dashboards }}
    {{ include "chart.dashboards" . | nindent 0 }}
  {{ end }}

  {{ if .Values.extraDeploy }}
    {{ include "chart.extraList" . | nindent 0 }}
  {{ end }}

{{- end -}}
