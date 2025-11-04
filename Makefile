.DEFAULT_GOAL := help
.PHONY: help
help: ## Display this help message
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@awk '/^[a-zA-Z0-9_.%-]+:.*## / {printf "%s : %s\n", $$1, substr($$0, index($$0, "##") + 3)}' $(MAKEFILE_LIST) | sort | column -t -s ':'
	@echo


CHART_SOURCES := $(shell find trufflehog)

trufflehog-%.tgz: $(CHART_SOURCES) ## Package up the current chart, eg. `make trufflehog-0.2.0.tgz`
	sed -i '' -e "s/^version:.*/version: $*/" trufflehog/Chart.yaml
	helm package trufflehog

.PHONY: index.yaml
index.yaml: ## Rebuild the helm chart index
	helm repo index . --url https://trufflesecurity.github.io/helm-charts/
