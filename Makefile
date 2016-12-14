TEMPLATES_DIR := templates
TEMPLATE_EXTENSION := yaml
PARAMETERS_DIR := parameters
PARAMETER_EXTENSION := json
TAGS_DIR := tags
TAGS_EXTENSION := json
FUNCTIONS_DIR := lambdas



.PHONY: provision delete

OPERATION=$(shell aws cloudformation describe-stacks --stack-name $(STACK_NAME) > /dev/null 2>&1; \
  if [ $$? -eq 0 ]; then echo "update-stack"; else echo "create-stack"; fi)
provision:
	aws cloudformation $(OPERATION) \
	  --stack-name $(STACK_NAME) \
	  --template-body file://$(TEMPLATES_DIR)/$(TEMPLATE).$(TEMPLATE_EXTENSION) \
	  --parameters file://$(PARAMETERS_DIR)/$(PARAMS).$(PARAMETER_EXTENSION) \
	  --tags file://$(TAGS_DIR)/$(TAGS).$(TAGS_EXTENSION) \
	  --capabilities CAPABILITY_IAM

delete:
	test -n "$(STACK_NAME)" || { echo "No STACK_NAME given!"; exit 1; }

	aws cloudformation delete-stack \
	  --stack-name $(STACK_NAME)

define INDEX_BODY
import logging
import os

# Module imports, if any, go here.
# from $(FUNCTION) import module1
# from $(FUNCTION) import module2

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def handler(event, context):
    """Entry point for the Lambda function."""
    logger.info('Hello world')


if __name__ == '__main__':
    handler(None, None)
endef
export INDEX_BODY

scaffold:
	test -n "$(FUNCTION)" || { echo "No FUNCTION given!"; exit 1; }
	test ! -d $(FUNCTIONS_DIR)/$(FUNCTION)_package || { echo "$(FUNCTION)_package already exists!"; exit 1; }

	mkdir -p $(FUNCTIONS_DIR)/$(FUNCTION)_package
	mkdir -p $(FUNCTIONS_DIR)/$(FUNCTION)_package/requirements
	echo "pyaml" >> $(FUNCTIONS_DIR)/$(FUNCTION)_package/requirements/common.txt
	echo "-r common.txt" >> $(FUNCTIONS_DIR)/$(FUNCTION)_package/requirements/dev.txt
	echo "pytest" >> $(FUNCTIONS_DIR)/$(FUNCTION)_package/requirements/dev.txt
	echo "mock" >> $(FUNCTIONS_DIR)/$(FUNCTION)_package/requirements/dev.txt
	echo "-r common.txt" >> $(FUNCTIONS_DIR)/$(FUNCTION)_package/requirements/lambda.txt
	mkdir -p $(FUNCTIONS_DIR)/$(FUNCTION)_package/$(FUNCTION)
	echo "$$INDEX_BODY" > $(FUNCTIONS_DIR)/$(FUNCTION)_package/index.py

invoke:
	test -n "$(FUNCTION)" || { echo "No FUNCTION given!"; exit 1; }
	python $(FUNCTIONS_DIR)/$(FUNCTION)_package/index.py

