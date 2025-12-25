{{/*
Define a reusable ClusterRole template.
If .Values.serviceAccount.roleRules is provided, it creates a ClusterRole inline.
Otherwise, it assumes an existing ClusterRole name given by .Values.serviceAccount.role.
*/}}
{{- define "common.clusterrole" -}}
{{- if .Values.serviceAccount.roleRules }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ include "common.names.serviceAccountName" . }}
  labels: {{- include "common.labels" . | nindent 4 }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "common.annotations" . | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
rules:
{{ toYaml .Values.serviceAccount.roleRules | indent 2 }}
{{- end }}
{{- end }}
