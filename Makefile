# One-click workflow for the Floci frontend deployment.
# Run these from the project root (frontend-deployment).
PS        = powershell -NoProfile -ExecutionPolicy Bypass -File
PORT      ?= 0
HOST_PORT ?= 8090

.DEFAULT_GOAL := help
.NOTPARALLEL:
.PHONY: help all up infra pipeline deploy expose test redeploy status destroy

help:
	@echo make all       - run the whole process: up, infra, pipeline, deploy, expose, test
	@echo make up        - start Docker containers and wait for Floci
	@echo make infra     - terraform init, validate, apply
	@echo make pipeline  - zip source, upload to S3, start CodePipeline
	@echo make deploy    - docker build, push, new task definition, update ECS
	@echo make expose    - publish the container on http://localhost:8090
	@echo make test      - smoke test on port 8090
	@echo make redeploy  - deploy, expose and test after you change the frontend
	@echo make status    - show what is running
	@echo make destroy   - terraform destroy and remove the proxy
	@echo Options: PORT=8501 for apps not on port 80, HOST_PORT=8090

all: up infra pipeline deploy expose test

up:
	$(PS) scripts/wait-for-floci.ps1

infra:
	$(PS) scripts/infra.ps1

pipeline:
	$(PS) scripts/run-pipeline.ps1

deploy:
	$(PS) scripts/deploy.ps1 -ContainerPort $(PORT)

expose:
	$(PS) scripts/expose.ps1 -HostPort $(HOST_PORT)

test:
	$(PS) scripts/smoke-test.ps1 -HostPort $(HOST_PORT)

redeploy: deploy expose test

status:
	$(PS) scripts/status.ps1

destroy:
	-docker rm -f frontend-proxy
	terraform -chdir=infra/environments/local destroy -auto-approve
