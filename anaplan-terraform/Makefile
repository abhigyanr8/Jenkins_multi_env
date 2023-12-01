SHELL := /usr/bin/env bash

# HOW TO EXECUTE

# Executing Terraform INIT
#	$ make tf-infra-init env=<env>
#    e.g.,
#       make tf-init env=dev

# Executing Terraform PLAN
#	$ make tf-plan env=<env>
#    e.g.,
#       make tf-plan env=dev

# Executing Terraform APPLY
#   $ make tf-apply env=<env>

# Executing Terraform DESTROY
#	$ make tf-destroy env=<env>

all-test: clean tf-plan

.PHONY: clean
clean:
	rm -rf .terraform

## AWS Infra Setup
.PHONY: tf-infra-init
tf-infra-init:
	cd core-sizing-aws-infra && terraform init -backend-config ../environment/${env}/backend.conf -reconfigure && terraform workspace select -or-create ${env} && terraform validate && terraform plan -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/infra.auto.tfvars

.PHONY: tf-infra-plan
tf-infra-plan:
	cd core-sizing-aws-infra && terraform workspace select -or-create ${env} && terraform fmt --recursive && terraform validate && terraform plan -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/infra.auto.tfvars

.PHONY: tf-infra-apply
tf-infra-apply:
	cd core-sizing-aws-infra && terraform workspace select -or-create ${env} && terraform fmt --recursive && terraform init -backend-config ../environment/${env}/backend.conf -reconfigure && terraform validate && terraform apply -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/infra.auto.tfvars -auto-approve

.PHONY: tf-infra-destroy
tf-infra-destroy:
	terraform workspace select -or-create ${env} && terraform destroy -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/infra.auto.tfvars -auto-approve

## AWS Service Setup
.PHONY: tf-service-init
tf-service-init:
	cd core-sizing-aws-service && terraform init -backend-config ../environment/${env}/backend.conf -reconfigure && terraform workspace select -or-create ${env} && terraform validate && terraform plan -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/service.auto.tfvars

.PHONY: tf-service-plan
tf-service-plan:
	cd core-sizing-aws-service && terraform workspace select -or-create ${env} && terraform fmt --recursive && terraform validate && terraform plan -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/service.auto.tfvars

.PHONY: tf-service-apply
tf-service-apply:
	cd core-sizing-aws-service && terraform workspace select -or-create ${env} && terraform fmt --recursive && terraform init -backend-config ../environment/${env}/backend.conf -reconfigure && terraform validate && terraform apply -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/service.auto.tfvars -auto-approve

.PHONY: tf-service-destroy
tf-service-destroy:
	terraform workspace select -or-create ${env} && terraform destroy -var-file ../environment/${env}/common.auto.tfvars -var-file ../environment/${env}/service.auto.tfvars -auto-approve

