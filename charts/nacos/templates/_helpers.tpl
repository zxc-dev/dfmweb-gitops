{{/*
Expand the name of the chart.
*/}}
{{- define "nacos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "nacos.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/name: {{ include "nacos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: stellantis-overseas-tsp
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "nacos.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nacos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Operator deployment name.
*/}}
{{- define "nacos.operator.fullname" -}}
{{- $def := printf "%s-operator" (include "nacos.name" .) -}}
{{- if .Values.operator.fullnameOverride -}}
{{- .Values.operator.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $release := .Release.Name -}}
{{- if contains $release $def -}}
{{- $def | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $release $def | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Operator ServiceAccount name.
*/}}
{{- define "nacos.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
{{- default (printf "%s-sa" (include "nacos.operator.fullname" .)) .Values.operator.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.operator.serviceAccount.name -}}
{{- end -}}
{{- end }}

{{/*
Instance fullname (used for the debug SA/Job/CRB).
*/}}
{{- define "nacos.fullname" -}}
{{- $def := include "nacos.name" . -}}
{{- $release := .Release.Name -}}
{{- if contains $release $def -}}
{{- $def | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $release $def | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}
