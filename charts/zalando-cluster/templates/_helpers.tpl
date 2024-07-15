{{/*
Expand the name of the chart.
*/}}
{{- define "zalando-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Cluster name as used in {cluster} templates of operator
*/}}
{{- define "zalando-cluster.clusterName" -}}
{{- printf "%s-zalando-%s" .Values.teamId (required "Cluster name is required" .Values.cluster.name) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zalando-cluster.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name (include "zalando-cluster.clusterName" . ) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zalando-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zalando-cluster.labels" -}}
helm.sh/chart: {{ include "zalando-cluster.chart" . }}
{{ include "zalando-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zalando-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zalando-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "zalando-cluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "zalando-cluster.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "zalando-cluster.fullClusterName" -}}
{{ .Values.teamId }}-zalando-{{ .Values.cluster.name }}
{{- end }}

{{- define "zalando-cluster.certificateSecretName" -}}
{{ include "zalando-cluster.fullClusterName" . }}-certificate
{{- end }}