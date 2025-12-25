{{/*
Imports Grafana dashboards from JSON files in dashboars folder.
*/}}
{{- define "chart.dashboards" -}}
{{- $name := include "common.names.fullname" . }}
{{- $namespace := .Release.Namespace }}
{{- if .Values.dashboards }}
{{- range $key, $value := .Values.dashboards }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $name }}-{{ $key }}-grafana-dashboard
  namespace: {{ $namespace }}
  labels:
    grafana_dashboard: "1"
data:
{{- $dashboardFound := false }}
{{- if (or (hasKey $value "json") (hasKey $value "base64")) }}
{{- $dashboardFound = true }}
  {{- print $key | nindent 2 }}.json:
    {{- if hasKey $value "json" }}
    |-
      {{- $value.json | nindent 6 }}
    {{- else if hasKey $value "base64" }}
    |-
      {{- $value.base64 | b64dec | nindent 6 }}
    {{- end }}
{{- end }}
{{- if not $dashboardFound }}
  {}
{{- end }}
---
{{- end }}
{{- end }}

{{- end -}}