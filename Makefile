#!make
SHELL:=/bin/bash

SED?=$(shell command -v gsed || command -v sed)

all: greet build

greet:
	$(info Hello OpenSlava 2023!)

clean:
	$(info --> Cleaning Up ...)
	@bash scripts/stop-services.sh
	@rm -f .env .env*bak
	@find gitlab -type d -maxdepth 1 -mindepth 1 -exec rm -rf {} +

build: env-check
	@bash scripts/build.sh

extract-token:
	@docker exec openslava-gitlab-ce gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token"

update-token-env:
	@cp .env .env.$(shell date +%Y%m%d).bak
	@$(SED) -i.$(shell date +%Y%m%d).bak 's/REPLACE_ONCE_GENERATED/$(shell docker exec openslava-gitlab-ce gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")/g' .env

runner-register: update-token-env
	@bash scripts/register-runner.sh

personal-token:
	@docker exec openslava-gitlab-ce gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: [:api], name: 'terraform'); token.set_token('my-tf-token-2023'); token.save"
	
build-ansible-image:
	$(info --> Building Ansible Image ...)
	docker build -t openslava-ansible:alpine -f ansible/Dockerfile .

build-ansible-image-no-cache:
	$(info --> Building Ansible Image --no-cache ...)
	docker build --no-cache --progress plain -t openslava-ansible:alpine -f ansible/Dockerfile .

env-check: 
	@if [ ! -f .env ]; then echo -e "Seems you are missing '.env' file.\nRun 'cp .env.default .env' to create one..."; exit 1; fi

vault-start:
	$(info --> Starting Vault ...)
	@docker compose -f vault/docker-compose.yml up -d

vault-configure: build-ansible-image
	@docker run --rm -it --name=openslava-ansible -v ${PWD}/vault:/vault --network=toolchain-network openslava-ansible:alpine ansible-playbook /vault/playbooks/main.yml

vault-clean: 
	$(info --> Cleaning Up Vault ...)
	@cd vault && docker compose down
	@rm -rf vault/.init_tokens vault/vault/data vault/vault/logs vault/vault/policies

grafana-start:
	$(info --> Starting Grafana ...)
	@docker compose -f grafana/docker-compose.yml up -d

grafana-configure: build-ansible-image
	@docker run --rm -it --name=openslava-ansible -v ${PWD}/grafana:/grafana --network=toolchain-network openslava-ansible:alpine ansible-playbook /grafana/playbooks/main.yml

grafana-clean: 
	$(info --> Cleaning Up Grafana ...)
	@cd grafana && docker compose down

sed-test:
	@echo using $(SED)
	@grep GITLAB_RUNNER_REGISTRATION_TOKEN .env
	@$(SED) -i.$(shell date +%Y%m%d).bak 's/REPLACE_ONCE_GENERATED/SOMETHING/g' .env
	@grep GITLAB_RUNNER_REGISTRATION_TOKEN .env