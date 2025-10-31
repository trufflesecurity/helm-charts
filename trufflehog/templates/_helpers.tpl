{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "trufflehog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "trufflehog.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "trufflehog.labels" -}}
helm.sh/chart: {{ include "trufflehog.chart" . }}
{{ include "trufflehog.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: scanner
app.kubernetes.io/part-of: trufflehog-enterprise
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "trufflehog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trufflehog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Pod labels
*/}}
{{- define "trufflehog.podLabels" -}}
{{ include "trufflehog.selectorLabels" . }}
app.kubernetes.io/component: scanner
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Common annotations
*/}}
{{- define "trufflehog.annotations" -}}
{{- with .Values.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Pod annotations
*/}}
{{- define "trufflehog.podAnnotations" -}}
{{- with .Values.podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Chart version
*/}}
{{- define "trufflehog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Environment variables
*/}}
{{- define "trufflehog.envVars" -}}
{{- if .Values.extraEnvVars }}
{{- range .Values.extraEnvVars }}
- name: {{ .name }}
{{- if .value }}
  value: {{ .value | quote }}
{{- else if .valueFrom }}
  valueFrom:
{{- if .valueFrom.configMapKeyRef }}
    configMapKeyRef:
      name: {{ .valueFrom.configMapKeyRef.name }}
      key: {{ .valueFrom.configMapKeyRef.key }}
{{- if .valueFrom.configMapKeyRef.optional }}
      optional: {{ .valueFrom.configMapKeyRef.optional }}
{{- end }}
{{- else if .valueFrom.secretKeyRef }}
    secretKeyRef:
      name: {{ .valueFrom.secretKeyRef.name }}
      key: {{ .valueFrom.secretKeyRef.key }}
{{- if .valueFrom.secretKeyRef.optional }}
      optional: {{ .valueFrom.secretKeyRef.optional }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Persistence volume specification
*/}}
{{- define "trufflehog.persistence.volume" -}}
{{- if eq .Values.persistence.type "pvc" }}
persistentVolumeClaim:
  claimName: {{ if .Values.persistence.pvc.existingClaim }}{{ .Values.persistence.pvc.existingClaim }}{{ else }}{{ include "trufflehog.fullname" . }}{{ end }}
{{- else if eq .Values.persistence.type "emptyDir" }}
emptyDir:
{{- if .Values.persistence.emptyDir }}
{{- toYaml .Values.persistence.emptyDir | nindent 2 }}
{{- end }}
{{- else if eq .Values.persistence.type "hostPath" }}
hostPath:
  path: {{ required "persistence.hostPath.path is required when persistence.type is hostPath" .Values.persistence.hostPath.path }}
{{- if .Values.persistence.hostPath.type }}
  type: {{ .Values.persistence.hostPath.type }}
{{- end }}
{{- else if eq .Values.persistence.type "custom" }}
{{- toYaml .Values.persistence.custom | nindent 0 }}
{{- end }}
{{- end -}}
