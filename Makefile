CURRENT=$(shell pwd)
OS := $(shell uname)
CHARTS := $(shell ls -d */ | cut -f1 -d'/')
EXAMPLE := activiti-cloud-full-example
name := example
domain := REPLACEME

.PHONY: ;

all: 
	@echo No targets provided. Nothing to do.

init:
	helm repo add activiti-cloud-helm-charts https://activiti.github.io/activiti-cloud-helm-charts
	helm repo add activiti-cloud-charts https://activiti.github.io/activiti-cloud-charts


# make install domain=nip.io 
install:
	helm upgrade $(name) ./$(EXAMPLE) --install --set global.gateway.domain=$(domain)

# make delete name=example 
delete:
	helm delete $(name) --purge

# make chart/template
$(foreach chart,$(CHARTS),$(chart)/template):
	$(eval CHART := $(subst /template,,$@))
	helm template ./$(CHART)

# make chart/build
$(foreach chart,$(CHARTS),$(chart)/build):
	$(eval CHART := $(subst /build,,$@))
	rm ./$(CHART)/requirements.lock
	helm dep build ./$(CHART)
	helm lint ./$(CHART)

# make chart/lint
$(foreach chart,$(CHARTS),$(chart)/lint):
	$(eval CHART := $(subst /lint,,$@))
	helm lint ./$(CHART)

$(foreach chart,$(CHARTS),$(chart)/release):
	$(eval CHART := $(subst /release,,$@))
	$(eval VERSION := $(shell sed -n 's/^version: //p' $(CHART)/Chart.yaml))
	rm $(CHART)/requirements.lock || true
	helm dep build $(CHART) 
	helm lint $(CHART)
	helm template $(CHART)
	helm package $(CHART)
	mv $(CHART)-$(VERSION).tgz docs	
	git pull
	helm repo index docs --url https://activiti.github.io/activiti-cloud-charts/
	git add $(CHART)/* || true
	git add docs/$(CHART)-$(VERSION).tgz
	git add docs/index.yaml
	git commit -m "release $(CHART)-$(VERSION)"
	git push

release: 
	make common/release
	make activiti-cloud-audit/release
	make activiti-cloud-events-adapter/release
	make activiti-cloud-modeling/release
	make activiti-cloud-demo-ui/release
	make activiti-cloud-gateway/release
	make activiti-cloud-query/release
	make activiti-keycloak/release
	make runtime-bundle/release
	make activiti-cloud-connector/release
	make activiti-cloud-notifications-graphql/release
	make infrastructure/release
	make application/release
	make activiti-cloud-full-example/release
