{{- define "streamingapp.labels" -}}
app.kubernetes.io/part-of: streamingapp
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end }}
