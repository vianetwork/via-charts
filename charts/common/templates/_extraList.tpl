{{- define "chart.extraList" -}}
{{- range .Values.extraDeploy }}
---
{{ include "common.valuesrender" (dict "value" . "context" $) }}
{{- end }}
{{- end -}}