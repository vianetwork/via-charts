{{/*
This template serves as a blueprint for all PersistentVolume objects that are created
within the common library.
*/}}
{{- define "common.classes.pv" -}}
{{- $namespace := .Release.Namespace }}
{{- $values := .Values.persistence -}}
{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.persistence -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}
{{- $pvcName := include "common.names.fullname" . -}}
{{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
  {{- if not (eq $values.nameOverride "-") -}}
    {{- $pvcName = printf "%v-%v" $pvcName $values.nameOverride -}}
  {{ end -}}
{{ end }}
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: {{ $pvcName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  annotations:
    {{- if $values.retain }}
    "helm.sh/resource-policy": keep
    {{- end }}
    {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  accessModes:
    - {{ required (printf "accessMode is required for PVC %v" $pvcName) $values.accessMode | quote }}
  capacity:
    storage: {{ required (printf "size is required for PVC %v" $pvcName) $values.size | quote }}
  persistentVolumeReclaimPolicy: {{ $values.persistentVolumeReclaimPolicy | default "Retain" }}
  volumeMode: {{ $values.volumeMode | default "Filesystem" }}
  claimRef:
    namespace: {{ $namespace }}
    name: {{ $pvcName }}
  {{- if $values.storageClass }}
  storageClassName: {{ if (eq "-" $values.storageClass) }}""{{- else }}{{ $values.storageClass | quote }}{{- end }}
  {{- end }}
  csi:
    driver: {{ required (printf "driver is required for PV %v" $pvcName) $values.csi.driver | quote }}
    volumeHandle: {{ required (printf "volumeHandle is required for PV %v" $pvcName) $values.csi.volumeHandle | quote }}
    {{- if $values.csi.fsType }}
    fsType: {{ $values.csi.fsType | quote }}
    {{- end }}
    {{- if $values.csi.volumeAttributes }}
    volumeAttributes:
      {{- toYaml $values.csi.volumeAttributes | nindent 8 }}
    {{- end }}
    {{- if (eq "ReadOnlyMany" $values.accessMode) }}
    readOnly: true
    {{- end }}
{{- end -}}
