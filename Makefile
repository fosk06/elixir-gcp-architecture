.PHONY: help test ;
.SILENT: help build;               # no need for @
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell

TODAY=`date '+%Y-%m-%d'`
## color variables 
Red=\033[0;31m
NC=\033[0m # No Color
Green=\033[0;32m
Blue=\033[0;36m

CONCURRENT_USERS=300
NUMBER_OF_REQUESTS=300

# import .env file
include .env
export

help:
	perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build release with docker
	@echo "$(Green)build release ..........................................$(NC)"
	docker build \
	--pull \
	--rm \
	-t api-nodes:latest \
	--build-arg app_name=api \
	--build-arg release_name=api \
	--build-arg secret_key_base=bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl \
	--build-arg bucket_url=gs://elixir_build_artifacts \
	--build-arg service_account_filename=service_account.json \
	.

release: ## build release with docker
	@echo "$(Green)build release ..........................................$(NC)"
	SECRET_KEY_BASE=bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl MIX_ENV=prod mix release api --overwrite


run: release ## run the project
	@echo "$(Green)run the project ..........................................$(NC)"
	PORT=4000 SERVICE_NAME="api" INTERNAL_IP="127.0.0.1" SECRET_KEY_BASE=bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl _build/prod/rel/api/bin/api start

run_local: release_local ## run the project
	@echo "$(Green)run the project ..........................................$(NC)"
	mix phx.server

deploy: # re deploy on gcp
	@echo "$(Green)build the app and redeploy ..........................................$(NC)"
	gcloud beta compute instances stop "elixir-instance-0" "elixir-instance-1" --zone "europe-west1-c"  --project "prestashop-data-integration" && \
	gcloud beta compute instances start "elixir-instance-0" "elixir-instance-1" --zone "europe-west1-c"  --project "prestashop-data-integration"

ssh:
	gcloud beta compute ssh --zone "europe-west1-c" "elixir-instance-0" --project ${GCP_PROJECT}

# sudo SECRET_KEY_BASE=bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl SERVICE_NAME=api INTERNAL_IP=10.2.0.18 PORT=80 /app/bin/api rpc 'IO.inspect(Node.self())'
# sudo SECRET_KEY_BASE=bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl SERVICE_NAME=api INTERNAL_IP=10.2.0.15 PORT=80 /app/bin/api rpc 'Node.ping(:"api@10.2.0.10")'