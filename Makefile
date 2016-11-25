TEMPLATES_DIR := templates
TEMPLATE_EXTENSION := yaml
PARAMETERS_DIR := parameters
PARAMETER_EXTENSION := json



.PHONY: provision delete

OPERATION=$(shell aws cloudformation describe-stacks --stack-name $(STACK_NAME) > /dev/null 2>&1; \
  if [ $$? -eq 0 ]; then echo "update-stack"; else echo "create-stack"; fi)
provision:
	aws cloudformation $(OPERATION) \
	  --stack-name $(STACK_NAME) \
	  --template-body file://$(TEMPLATES_DIR)/$(TEMPLATE).$(TEMPLATE_EXTENSION) \
	  --parameters file://$(PARAMETERS_DIR)/$(PARAMS).$(PARAMETER_EXTENSION) \
	  --capabilities CAPABILITY_IAM


delete:
	aws cloudformation delete-stack \
	  --stack-name $(STACK_NAME)
