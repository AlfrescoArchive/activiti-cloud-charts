CURRENT=$(shell pwd)
OS := $(shell uname)
CHARTS := $(shell ls -d */ | cut -f1 -d'/')
EXAMPLE := activiti-cloud-full-example
name := example
domain := $(shell kubectl get cm ingress-config -o=go-template --template='{{.data.domain}}' -n jx)

.PHONY: ;

all: 
	@echo No targets provided. Nothing to do.

init:
	helm repo add activiti-cloud-helm-charts https://activiti.github.io/activiti-cloud-helm-charts
	helm repo add activiti-cloud-charts https://activiti.github.io/activiti-cloud-charts

up: application/up infrastructure/up
	./dep-up.sh $(EXAMPLE)

# make install domain=nip.io 
install:
	@echo helm upgrade $(name) ./$(EXAMPLE) --install --set global.gateway.domain=$(domain)

# make delete name=example 
delete:
	@echo helm delete $(name) --purge

# make chart/up
$(foreach chart,$(CHARTS),$(chart)/up):
	$(eval CHART := $(subst /up,,$@))
	./dep-up.sh $(CHART)
	
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
