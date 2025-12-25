{{/*
TheCclusterRoleBinding object to be created.
*/}}
{{- define "common.clusterrolebinding" }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ include "common.names.serviceAccountName" . }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
subjects:
- kind: ServiceAccount
  name: {{ include "common.names.serviceAccountName" . }}
  namespace: {{ .Release.Namespace }}
roleRef:
  kind: ClusterRole
  name: {{ default (include "common.names.serviceAccountName" .) .Values.serviceAccount.role }}
  apiGroup: rbac.authorization.k8s.io
{{- end }}
