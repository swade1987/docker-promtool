CURRENT_WORKING_DIR=$(shell pwd)

#------------------------------------------------------------------
# Project build information
#------------------------------------------------------------------
PROJNAME          		:= promtool
VENDOR            		:= eeveebank
MAINTAINER        		:= platform@mettle.co.uk

GIT_REPO          		:= github.com/$(VENDOR)/$(PROJNAME)
GIT_SHA           		:= $(shell git rev-parse --verify HEAD)
BUILD_DATE        		:= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

QUAY_REPO         		:= quay.io/mettle
QUAY_USERNAME     		:= "mettle+docker_promtool"
QUAY_PASSWORD     		?="unknown"

GCR_REPO		  		:= eu.gcr.io/mettle-bank
GCLOUD_SERVICE_KEY		?="unknown"
GCLOUD_SERVICE_EMAIL 	:= circle-ci@mettle-bank.iam.gserviceaccount.com
GOOGLE_PROJECT_ID		:= mettle-bank
GOOGLE_COMPUTE_ZONE		:= europe-west2-a

PROMETHEUS_VERSION		:= v2.19.0
IMAGE             		:= $(PROJNAME):$(PROMETHEUS_VERSION)

#------------------------------------------------------------------
# CI targets
#------------------------------------------------------------------

build:
	docker build \
    --build-arg git_repository=`git config --get remote.origin.url` \
    --build-arg git_branch=`git rev-parse --abbrev-ref HEAD` \
    --build-arg git_commit=`git rev-parse HEAD` \
    --build-arg built_on=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg PROMETHEUS_VERSION=$(PROMETHEUS_VERSION) \
    -t $(IMAGE) .

push-to-quay:
	docker login -u $(QUAY_USERNAME) -p $(QUAY_PASSWORD) quay.io
	docker tag $(IMAGE) $(QUAY_REPO)/$(IMAGE)
	docker push $(QUAY_REPO)/$(IMAGE)
	docker rmi $(QUAY_REPO)/$(IMAGE)
	docker logout

push-to-gcr: configure-gcloud-cli
	docker tag $(IMAGE) $(GCR_REPO)/$(IMAGE)
	gcloud docker -- push $(GCR_REPO)/$(IMAGE)
	docker rmi $(GCR_REPO)/$(IMAGE)

configure-gcloud-cli:
	echo '$(GCLOUD_SERVICE_KEY)' | base64 --decode > /tmp/gcloud-service-key.json
	gcloud auth activate-service-account $(GCLOUD_SERVICE_EMAIL) --key-file=/tmp/gcloud-service-key.json
	gcloud --quiet config set project $(GOOGLE_PROJECT_ID)
	gcloud --quiet config set compute/zone $(GOOGLE_COMPUTE_ZONE)

scan: build
	trivy --light -s "UNKNOWN,MEDIUM,HIGH,CRITICAL" --exit-code 1 $(IMAGE)