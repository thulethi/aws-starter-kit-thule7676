TF_ARGS =
TF_VAR_FILE = terraform.tfvars

.PHONY: clean
#%% Terraform: Clean local state
clean:
	- rm -rf .terraform

.PHONY: init
#%% Terraform: Initialize local state
init:
	terraform init

.PHONY: staging production
staging production: init
	terraform workspace select $@ || terraform workspace new $@

#%% Terraform: Activate Staging workspace
staging: # doc only

#%% Terraform: Activate Production workspace
production: # doc only

.PHONY: plan apply destroy
plan apply destroy:
	terraform $@ -var-file=$(TF_VAR_FILE) $(TF_ARGS)

#%% Terraform: Plan active workspace changes
plan: # doc only

#%% Terraform: Apply active workspace changes
apply: # doc only

#%% Terraform: Destroy active workspace changes
destroy: # doc only
