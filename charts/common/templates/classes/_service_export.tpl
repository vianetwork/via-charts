{{/*
This template serves as a blueprint for all Service objects that are created
within the common library.
*/}}
{{- define "common.classes.serviceexport" -}}
{{- $values := .Values.service -}}
{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.service -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}

{{- $serviceName := include "common.names.fullname" . -}}
{{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
  {{- $serviceName = printf "%v-%v" $serviceName $values.nameOverride -}}
{{ end -}}
---
apiVersion: net.gke.io/v1
kind: ServiceExport
metadata:
  name: {{ $serviceName }}
  namespace: {{ .Release.Namespace }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  annotations:
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
    {{ toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
