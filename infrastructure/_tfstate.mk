CF_TEMPLATE_FILE = .tfstate.cf.yml
CF_PROJECT_NAME = $(shell cat .project-uuid)

CF_STATE_BUCKET_NAME = terraform-state-$(CF_PROJECT_NAME)
CF_LOCK_TABLE_NAME = terraform-locks-$(CF_PROJECT_NAME)

CF_STACK_NAME = terraform-setup-$(CF_PROJECT_NAME)

#%% Create project UUID
.project-uuid:
	head -1000 /dev/urandom | shasum -a 256 | head -c10 | tee $@
	@echo

.PHONY: tfstate-create
#%% CloudFormation: Deploy Terraform state infrastructure
tfstate-create: $(CF_TEMPLATE_FILE) .project-uuid
	$(eval T = $(or $(CF_PROJECT_NAME), $(error CF_PROJECT_NAME missing)))
	aws cloudformation deploy \
		--region eu-central-1 \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file $(CF_TEMPLATE_FILE) \
		--stack-name $(CF_STACK_NAME) \
		--parameter-overrides \
			StateBucketName=$(CF_STATE_BUCKET_NAME) \
			LockTableName=$(CF_LOCK_TABLE_NAME)

.PHONY: tfstate-destroy
#%% CloudFormation: Destroy Terraform state infrastructure
tfstate-destroy: $(CF_TEMPLATE_FILE)
	aws cloudformation delete-stack \
		--region eu-central-1 \
		--stack-name $(CF_STACK_NAME)
