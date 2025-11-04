CHART_SOURCES := $(shell find trufflehog)

trufflehog-%.tgz: $(CHART_SOURCES)
	helm package trufflehog

.PHONY: index.yaml
index.yaml: *.tgz
	helm repo index . --url https://trufflesecurity.github.io/helm-charts/
