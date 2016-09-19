IMAGENAME=mswinson/docker-pypi-mirror
SHELL=/bin/bash
TAG=$(IMAGENAME)
ifeq ($(SERVER_ENV), development)
	TAG="$(IMAGENAME):develop"
endif

build:
	docker build --tag=$(TAG) .

test:
	@echo "no tests"

shell:
	docker run -t -i $(TAG) $(SHELL)

